//
//  Artist+CoreDataProperties.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artist.h"
@class Album;
@class Genre;

NS_ASSUME_NONNULL_BEGIN

@interface Artist (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *biography;
@property (nullable, nonatomic, retain) NSString *imageLocalURL;
@property (nullable, nonatomic, retain) NSNumber *isFavorite;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *popularity;
@property (nullable, nonatomic, retain) NSString *spotifyID;
@property (nullable, nonatomic, retain) NSSet<Album *> *albums;
@property (nullable, nonatomic, retain) NSSet<Genre *> *genres;

@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(Album *)value;
- (void)removeAlbumsObject:(Album *)value;
- (void)addAlbums:(NSSet<Album *> *)values;
- (void)removeAlbums:(NSSet<Album *> *)values;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet<Genre *> *)values;
- (void)removeGenres:(NSSet<Genre *> *)values;

@end

NS_ASSUME_NONNULL_END
