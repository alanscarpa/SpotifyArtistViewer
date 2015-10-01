//
//  Artist+CoreDataProperties.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artist (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *imageLocalURL;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *album;

@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addAlbumObject:(NSManagedObject *)value;
- (void)removeAlbumObject:(NSManagedObject *)value;
- (void)addAlbum:(NSSet<NSManagedObject *> *)values;
- (void)removeAlbum:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
