//
//  Artist.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString *const _Nonnull kArtistEntityName;

@class Album;

NS_ASSUME_NONNULL_BEGIN

@interface Artist : NSManagedObject

- (Album *)albumWithSpotifyID:(NSString *)spotifyID;
- (NSArray *)albumsSortedByName;
- (void)setDetailsWithName:(NSString *)name spotifyID:(NSString *)spotifyID imageURLString:(NSString *)imageUrlString popularity:(NSString *)popularity genres:(NSSet *)genres;

@end

NS_ASSUME_NONNULL_END

#import "Artist+CoreDataProperties.h"
