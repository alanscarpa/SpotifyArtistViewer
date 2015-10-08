//
//  NSFetchedResultsController+Setup.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (Setup)

+ (NSFetchedResultsController *)observeFavoriteArtistsInManageObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
