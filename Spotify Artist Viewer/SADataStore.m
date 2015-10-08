//
//  SADataStore.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SADataStore.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Artist.h"
#import "Album.h"
#import "Song.h"
#import "Genre.h"

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerForApplicationNotifications];
    }
    return self;
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

#pragma mark - Notifications

- (void)registerForApplicationNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationWillTerminateNotification:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:[UIApplication sharedApplication]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationWillTerminateNotification:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:[UIApplication sharedApplication]];
#warning also save on will resign active
}

- (void)handleApplicationWillTerminateNotification:(NSNotification *)notification {
    if (self.managedObjectContext.hasChanges) {
        [self save];
    }
}

#pragma mark - Save Methods

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

#pragma mark - Update Methods

- (void)flagArtistAsFavorite:(Artist *)artist {
    artist.isFavorite = @(YES);
    [[SADataStore sharedDataStore] save];
}

- (void)unflagArtistAsFavorite:(Artist *)artist {
    artist.isFavorite = @(NO);
    [[SADataStore sharedDataStore] save];
}

#pragma mark - Retrieval Methods

- (NSArray *)fetchAllArtists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kArtistEntityName];
    return [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
}

- (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kArtistEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (NSArray *)fetchFavoritedArtists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kArtistEntityName];
    NSSortDescriptor *sortArtistsByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    request.predicate = predicate;
    request.sortDescriptors = @[sortArtistsByName];
    return [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
}

- (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kAlbumEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (NSArray *)fetchAllSongsFromAlbum:(Album *)album {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kSongEntityName];
    NSSortDescriptor *sortSongsByTrackNumber = [NSSortDescriptor sortDescriptorWithKey:@"trackNumber" ascending:YES];
    request.sortDescriptors = @[sortSongsByTrackNumber];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"album == %@", album];
    request.predicate = predicate;
    return [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
}

#pragma mark - Insert Methods

- (Artist *)insertNewArtistWithSpotifyID:(NSString *)spotifyID {
    Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:kArtistEntityName inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
    artist.spotifyID = spotifyID;
    return artist;
}

- (Album *)insertNewAlbum {
    return [NSEntityDescription insertNewObjectForEntityForName:kAlbumEntityName inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
}

- (Song *)insertNewSong {
    return [NSEntityDescription insertNewObjectForEntityForName:kSongEntityName inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
}

- (Genre *)insertNewGenre {
    return [NSEntityDescription insertNewObjectForEntityForName:kGenreEntityName inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
}

@end
