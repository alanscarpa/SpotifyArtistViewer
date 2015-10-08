//
//  SACoreDataTransformer.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Artist;
@class Album;

@interface SACoreDataTransformer : NSObject

+ (NSArray *)artistsFromDictionary:(NSDictionary *)JSONDictionary;
+ (NSArray *)albumsFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist;
+ (NSArray *)songsFromDictionary:(NSDictionary *)JSONDictionary forAlbum:(Album *)album;
+ (NSString *)bioFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist;

@end
