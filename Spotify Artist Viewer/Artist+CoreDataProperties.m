//
//  Artist+CoreDataProperties.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artist+CoreDataProperties.h"

@implementation Artist (CoreDataProperties)

@dynamic imageLocalURL;
@dynamic name;
@dynamic spotifyID;
@dynamic popularity;
@dynamic biography;
@dynamic isFavorite;
@dynamic album;
@dynamic genre;

@end
