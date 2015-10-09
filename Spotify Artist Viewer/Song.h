//
//  Song.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString *const _Nonnull kSongEntityName;

@class Album;

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSManagedObject

- (void)setDetailsWithDictionary:(NSDictionary *)details;

@end

NS_ASSUME_NONNULL_END

#import "Song+CoreDataProperties.h"
