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

+ (Artist *)artistWithSpotifyID:(NSString *)spotifyID;
- (Album *)albumWithSpotifyID:(NSString *)spotifyID;
- (NSArray *)albumsSortedByName;

@end

NS_ASSUME_NONNULL_END

#import "Artist+CoreDataProperties.h"
