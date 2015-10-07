//
//  SADataStore.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@class NSManagedObjectContext;
@class Artist;
@class Album;
@class Song;

@interface SADataStore : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedDataStore;

- (void)save;

- (NSArray *)fetchFavoritedArtists;
- (NSArray *)fetchAllArtists;
- (UIImage *)fetchLocalImageWithArtist:(Artist *)artist;
- (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID;
- (Artist *)insertNewArtistWithSpotifyID:(NSString *)spotifyID;
- (void)saveArtistToFavorites:(Artist *)artist;

- (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID;
- (void)saveArtistAlbums:(Album *)album;

- (void)fetchSongsFromAlbum:(Album *)album withCompletionBlock:(void (^)(NSArray  *songs, NSError *error))completionBlock; ///?????
- (NSArray *)songsFromCoreDataAlbum:(Album *)album;

@end
