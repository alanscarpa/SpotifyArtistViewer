//
//  Album+CoreDataProperties.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface Album (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *imageLocalURL;
@property (nullable, nonatomic, retain) Artist *artist;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *song;

@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addSongObject:(NSManagedObject *)value;
- (void)removeSongObject:(NSManagedObject *)value;
- (void)addSong:(NSSet<NSManagedObject *> *)values;
- (void)removeSong:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
