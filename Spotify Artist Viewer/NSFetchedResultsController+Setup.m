//
//  NSFetchedResultsController+Setup.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "NSFetchedResultsController+Setup.h"

@implementation NSFetchedResultsController (Setup)

+ (NSFetchedResultsController *)observeFavoriteArtistsInManageObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Artist"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    fetchRequest.predicate = predicate;
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

@end
