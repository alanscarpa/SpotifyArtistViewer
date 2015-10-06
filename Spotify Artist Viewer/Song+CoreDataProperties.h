//
//  Song+CoreDataProperties.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/6/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *trackNumber;
@property (nullable, nonatomic, retain) NSString *spotifyID;
@property (nullable, nonatomic, retain) Album *album;

@end

NS_ASSUME_NONNULL_END
