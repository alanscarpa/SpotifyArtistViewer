//
//  Album.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString *const _Nonnull kAlbumEntityName;

@class Song;

NS_ASSUME_NONNULL_BEGIN

@interface Album : NSManagedObject

- (Song *)songWithSpotifyID:(NSString *)spotifyID;
- (NSArray *)songsSortedByTrackNumber;
- (void)setDetailsWithName:(NSString *)name spotifyID:(NSString *)spotifyID andImageURLString:(NSString *)imageURLString;

@end

NS_ASSUME_NONNULL_END

#import "Album+CoreDataProperties.h"
