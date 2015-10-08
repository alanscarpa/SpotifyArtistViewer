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
@class Genre;

@interface SADataStore : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedDataStore;

- (void)save;

- (NSArray *)fetchFavoritedArtists;
- (NSArray *)fetchAllArtists;
- (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID;
- (Artist *)insertNewArtistWithSpotifyID:(NSString *)spotifyID;
- (void)flagArtistAsFavorite:(Artist *)artist;
- (void)unflagArtistAsFavorite:(Artist *)artist;

- (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID;
- (Album *)insertNewAlbum;

- (NSArray *)fetchAllSongsFromAlbum:(Album *)album;
- (Song *)insertNewSong;

- (Genre *)insertNewGenre;

@end
