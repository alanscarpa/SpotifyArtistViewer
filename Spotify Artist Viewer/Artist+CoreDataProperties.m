//
//  Artist+CoreDataProperties.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artist+CoreDataProperties.h"

@implementation Artist (CoreDataProperties)

@dynamic biography;
@dynamic imageLocalURL;
@dynamic isFavorite;
@dynamic name;
@dynamic popularity;
@dynamic spotifyID;
@dynamic albums;
@dynamic genres;

@end
