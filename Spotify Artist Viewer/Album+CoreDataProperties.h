//
//  Album+CoreDataProperties.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Album.h"
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Album (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageLocalURL;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *spotifyID;
@property (nullable, nonatomic, retain) Artist *artist;
@property (nullable, nonatomic, retain) NSSet<Song *> *song;

@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addSongObject:(Song *)value;
- (void)removeSongObject:(Song *)value;
- (void)addSong:(NSSet<Song *> *)values;
- (void)removeSong:(NSSet<Song *> *)values;

@end

NS_ASSUME_NONNULL_END
