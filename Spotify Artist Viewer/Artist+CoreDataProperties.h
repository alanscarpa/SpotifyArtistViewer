//
//  Artist+CoreDataProperties.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artist.h"
#import "Genre.h"
#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artist (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageLocalURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *spotifyID;
@property (nullable, nonatomic, retain) NSString *popularity;
@property (nullable, nonatomic, retain) NSString *biography;
@property (nullable, nonatomic, retain) NSSet<Album *> *album;
@property (nullable, nonatomic, retain) NSSet<Genre *> *genre;

@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addAlbumObject:(Album *)value;
- (void)removeAlbumObject:(Album *)value;
- (void)addAlbum:(NSSet<Album *> *)values;
- (void)removeAlbum:(NSSet<Album *> *)values;

- (void)addGenreObject:(Genre *)value;
- (void)removeGenreObject:(Genre *)value;
- (void)addGenre:(NSSet<Genre *> *)values;
- (void)removeGenre:(NSSet<Genre *> *)values;

@end

NS_ASSUME_NONNULL_END
