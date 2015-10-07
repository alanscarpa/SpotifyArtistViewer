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
+ (void)addArtist:(Artist *)artist toFavorites:(SADataStore *)dataStore;
+ (UIImage *)localImageWithArtist:(Artist *)artist;
+ (void)saveSongs:(NSArray *)songs fromAlbum:(Album *)album toCoreData:(SADataStore *)dataStore;
+ (NSArray *)songsFromCoreDataAlbum:(Album *)album;
+ (void)songsFromAlbum:(Album *)album withCompletionBlock:(void (^)(NSArray  *songs, NSError *error))completionBlock;
+ (NSArray *)artistsFromDictionary:(NSDictionary *)JSONDictionary;
+ (NSArray *)albumsFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist;
+ (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID;
+ (NSArray *)songsFromDictionary:(NSDictionary *)JSONDictionary forAlbum:(Album *)album;
+ (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID;
+ (void)saveArtist:(Artist *)artist albumsToCoreData:(SADataStore *)dataStore;

@end
