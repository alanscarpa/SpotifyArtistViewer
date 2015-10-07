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
#import "SACoreDataTransformer.h"

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

+ (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ArtistEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
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

+ (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

#pragma mark - Data Save Methods

+ (void)saveArtist:(Artist *)artist albumsToCoreData:(SADataStore *)dataStore {
    NSMutableArray *artistAlbums = [[NSMutableArray alloc] init];
    [SAAFNetworkingManager getArtistAlbums:artist.spotifyID withCompletionHandler:^(NSArray *albums, NSError *error) {
        for (Album *artistAlbum in albums) {
            [artistAlbums addObject:artistAlbum];
        }
        artist.album = [NSSet setWithArray:artistAlbums];
        [dataStore save];
    }];
}

+ (void)saveArtist:(Artist *)artist toFavorites:(SADataStore *)dataStore {
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
