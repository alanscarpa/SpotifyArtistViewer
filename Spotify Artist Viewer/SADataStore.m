//
//  SADataStore.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SADataStore.h"
#import "Artist.h"
#import "SDWebImageDownloader.h"
#import "SAAFNetworkingManager.h"

NSString *const kPhotosDirectory = @"Photos";

@interface SADataStore ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation SADataStore

+ (instancetype)sharedDataStore {
    static id sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataStore = [[self alloc] init];
    });
    return sharedDataStore;
}

- (void)save {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Data Retrieval Methods

- (NSArray *)favoritedArtists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ArtistEntityName];
    NSSortDescriptor *sortArtistsByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    request.predicate = predicate;
    request.sortDescriptors = @[sortArtistsByName];
    return [self.managedObjectContext executeFetchRequest:request error:nil];
}

#pragma mark - Artist Methods

+ (void)addArtist:(Artist *)artist toFavorites:(SADataStore *)dataStore {
    [self saveArtistPhoto:artist];
    [self saveArtist:artist toCoreData:dataStore];
}

+ (void)saveArtistPhoto:(Artist *)artist {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:artist.imageLocalURL] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            [self saveImage:image path:artist.spotifyID];
        }
    }];
}

+ (void)saveArtist:(Artist *)artist toCoreData:(SADataStore *)dataStore {
    artist.isFavorite = @(YES);
    NSMutableArray *artistAlbums = [[NSMutableArray alloc] init];
    [SAAFNetworkingManager getArtistAlbums:artist.spotifyID withCompletionHandler:^(NSArray *albums, NSError *error) {
        for (Album *artistAlbum in albums) {
            [artistAlbums addObject:artistAlbum];
        }
        artist.album = [NSSet setWithArray:artistAlbums];
        [dataStore save];
    }];
}

+ (NSArray *)artistsFromDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc] init];
    for (NSDictionary *artistDictionary in JSONDictionary[@"artists"][@"items"]) {
        [artistsFromSearch addObject:[self artistFromDictionary:artistDictionary]];
    }
    return artistsFromSearch;
}

+ (Artist *)artistFromDictionary:(NSDictionary *)artistDictionary {
    Artist *artistFromCoreData = [self artistFromCoreDataWithID:artistDictionary[@"id"]];
    if (!artistFromCoreData) {
        Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:ArtistEntityName inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
        [self setDetailsForArtist:artist FromDictionary:artistDictionary];
        return artist;
    } else {
        [self setDetailsForArtist:artistFromCoreData FromDictionary:artistDictionary];
        return artistFromCoreData;
    }
}

+ (Artist *)artistFromCoreDataWithID:(NSString *)spotifyID {
    NSArray *existingArtists = [self fetchExistingArtistsFromCoreData];
    if (existingArtists.count > 0) {
        for (int i = 0; i < existingArtists.count; i++) {
            if ([[existingArtists[i] spotifyID] isEqualToString:spotifyID]) {
                return existingArtists[i];
            }
        }
    }
    return nil;
}

+ (NSArray *)fetchExistingArtistsFromCoreData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ArtistEntityName];
    return [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
}

+ (void)setDetailsForArtist:(Artist *)artist FromDictionary:(NSDictionary *)artistDictionary {
    artist.name = artistDictionary[@"name"];
    artist.spotifyID = artistDictionary[@"id"];
    if ([artistDictionary[@"images"] count] > 0) {
        artist.imageLocalURL = [[NSURL URLWithString:artistDictionary[@"images"][0][@"url"]] absoluteString];
    }
    [self setGenres:artistDictionary[@"genres"] ForArtist:artist];
    artist.popularity = [NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]];
}

+ (void)setGenres:(NSArray *)genres ForArtist:(Artist *)artist {
    for (NSString *genreName in genres) {
        if (![self artist:artist HasGenreNamed:genreName]) {
            Genre *genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            genre.name = genreName;
            [artist addGenreObject:genre];
        }
    }
}

+ (BOOL)artist:(Artist *)artist HasGenreNamed:(NSString *)genreName {
    for (Genre *genre in artist.genre) {
        if ([genre.name isEqualToString:genreName]) {
            return YES;
        }
    }
    return NO;
}

+ (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ArtistEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

#pragma mark - Album Methods

+ (NSArray *)albumsFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist {
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        if (![self doesArtist:artist alreadyHaveAlbum:dictionary]) {
            Album *newAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            [self updateArtist:artist album:newAlbum fromDictionary:dictionary];
            [artist addAlbumObject:newAlbum];
        }
    }
    return [artist.album allObjects];
}

+ (BOOL)doesArtist:(Artist *)artist alreadyHaveAlbum:(NSDictionary *)dictionary {
    for (Album *album in [artist.album allObjects]) {
        if ([dictionary[@"id"] isEqualToString:album.spotifyID]) {
            [self updateArtist:artist album:album fromDictionary:dictionary];
            return YES;
        }
    }
    return NO;
}

+ (void)updateArtist:(Artist *)artist album:(Album *)album fromDictionary:(NSDictionary *)dictionary {
    album.name = dictionary[@"name"];
    album.spotifyID = dictionary[@"id"];
    if ([dictionary[@"images"] count]>0) {
        album.imageLocalURL = dictionary[@"images"][0][@"url"];
    }
}

#pragma mark - Song Methods

+ (NSArray *)songsFromDictionary:(NSDictionary *)JSONDictionary forAlbum:(Album *)album {
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        if (![self songOnAlbum:album existsInDictionary:dictionary]) {
            Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            [self updateSong:newSong withDetails:dictionary];
            [album addSongObject:newSong];
        }
    }
    return [album.song allObjects];
}

+ (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

+ (BOOL)songOnAlbum:(Album *)album existsInDictionary:(NSDictionary *)dictionary {
    for (Song *song in album.song) {
        if ([song.spotifyID isEqualToString:dictionary[@"id"]]) {
            [self updateSong:song withDetails:dictionary];
            return YES;
        }
    }
    return NO;
}

+ (void)updateSong:(Song *)song withDetails:(NSDictionary *)dictionary {
    song.name = dictionary[@"name"];
    song.trackNumber = dictionary[@"track_number"];
    song.spotifyID = dictionary[@"id"];
}

+ (void)songsFromAlbum:(Album *)album withCompletionBlock:(void (^)(NSArray  *songs, NSError *error))completionBlock {
    if (album.song.count > 0) {
        completionBlock([self songsFromCoreDataAlbum:album], nil);
    } else {
        [SAAFNetworkingManager getAlbumSongs:album.spotifyID withCompletionHandler:^(NSArray *songs, NSError *error) {
            [[SADataStore sharedDataStore] save];
            completionBlock([songs sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"trackNumber" ascending:YES]]], nil);
        }];
    }
}

+ (NSArray *)songsFromCoreDataAlbum:(Album *)album {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    NSSortDescriptor *sortSongsByTrackNumber = [NSSortDescriptor sortDescriptorWithKey:@"trackNumber" ascending:YES];
    request.sortDescriptors = @[sortSongsByTrackNumber];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"album == %@", album];
    request.predicate = predicate;
    return [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
}

+ (void)saveSongs:(NSArray *)songs fromAlbum:(Album *)album toCoreData:(SADataStore *)dataStore {
    for (Song *song in songs) {
        Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:dataStore.managedObjectContext];
        newSong.name = song.name;
        newSong.trackNumber = song.trackNumber;
        [album addSongObject:newSong];
    }
    [dataStore save];
}

#pragma mark - Helper Methods

+ (UIImage *)localImageWithArtist:(Artist *)artist {
    if (artist.imageLocalURL) {
        return [UIImage imageWithContentsOfFile:[[self photosDirectory] stringByAppendingPathComponent:artist.spotifyID]];
    }
    return nil;
}

+ (void)saveImage:(UIImage *)image path:(NSString *)path {
    [self createPhotosDirectoryIfNecessary];
    [UIImagePNGRepresentation(image) writeToFile:[[self photosDirectory] stringByAppendingPathComponent:path]
                                      atomically:YES];
}

+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)photosDirectory {
    return [[self documentsDirectory] stringByAppendingPathComponent:kPhotosDirectory];
}

+ (void)createPhotosDirectoryIfNecessary {
    NSError *error = nil;
    NSString *photosDirectory = [self photosDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:photosDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:photosDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

@end
