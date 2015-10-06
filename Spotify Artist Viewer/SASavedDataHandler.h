//
//  SASavedDataHandler.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SADataStore.h"
#import "Artist.h"

@interface SASavedDataHandler : NSObject

+ (void)addArtist:(Artist *)artist toFavorites:(SADataStore *)dataStore;
+ (UIImage *)localImageWithArtist:(Artist *)artist;
+ (void)saveSongs:(NSArray *)songs fromAlbum:(Album *)album toCoreData:(SADataStore *)dataStore;
+ (NSArray *)songsFromCoreDataAlbum:(Album *)album;
+ (void)songsFromAlbum:(Album *)album withCompletionBlock:(void (^)(NSArray  *songs, NSError *error))completionBlock;
+ (Artist *)artistFromDictionary:(NSDictionary *)artistDictionary;
+ (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID;
+ (BOOL)doesArtist:(Artist *)artist alreadyHaveAlbum:(NSDictionary *)dictionary;
+ (void)updateArtist:(Artist *)artist album:(Album *)album fromDictionary:(NSDictionary *)dictionary;
+ (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID;
+ (BOOL)songOnAlbum:(Album *)album existsInDictionary:(NSDictionary *)dictionary;
+ (void)updateSong:(Song *)song withDetails:(NSDictionary *)dictionary;

@end
