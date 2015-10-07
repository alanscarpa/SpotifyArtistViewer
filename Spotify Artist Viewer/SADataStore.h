//
//  SADataStore.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "SADataStore.h"
#import "Artist.h"

@interface SADataStore : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
+ (instancetype)sharedDataStore;
- (void)save;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)favoritedArtists;
+ (void)saveArtist:(Artist *)artist toFavorites:(SADataStore *)dataStore;
+ (UIImage *)localImageWithArtist:(Artist *)artist;
+ (void)songsFromAlbum:(Album *)album withCompletionBlock:(void (^)(NSArray  *songs, NSError *error))completionBlock;
+ (NSArray *)songsFromCoreDataAlbum:(Album *)album;
+ (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID;
+ (void)saveArtist:(Artist *)artist albumsToCoreData:(SADataStore *)dataStore;
+ (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID;

@end
