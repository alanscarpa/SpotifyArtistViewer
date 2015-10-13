//
//  Genre.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString *const _Nonnull kGenreEntityName;

@class Artist;

NS_ASSUME_NONNULL_BEGIN

@interface Genre : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Genre+CoreDataProperties.h"
