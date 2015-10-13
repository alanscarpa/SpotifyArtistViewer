//
//  SAAFNetworkingManager.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/29/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAAFNetworkingManager : NSObject

+ (void)searchForArtistsWithQuery:(NSString *)query
                  withReturnLimit:(NSInteger)limit
                       withOffset:(NSInteger)offSet
            withCompletionHandler:(void (^)(NSArray *artists, NSError *error))completionHandler;
+ (void)getArtistAlbums:(NSString *)spotifyID withCompletionHandler:(void (^)(NSArray  *albums, NSError *error))completionHandler;
+ (void)getAlbumSongs:(NSString *)albumSpotifyID withCompletionHandler:(void (^)(NSArray *songs, NSError *error))completionHandler;
+ (void)getArtistBiography:(NSString *)spotifyID withCompletionHandler:(void (^)(NSString *artistBio, NSError *error))completionHandler;

@end
