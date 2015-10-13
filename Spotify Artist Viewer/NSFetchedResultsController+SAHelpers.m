//
//  NSFetchedResultsController+Setup.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "NSFetchedResultsController+SAHelpers.h"

@implementation NSFetchedResultsController (SAHelpers)

+ (NSFetchedResultsController *)sa_createFavoriteArtistsFetchedResultsControllerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext; {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Artist"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:managedObjectContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

@end
