//
//  NSSet+Organizer.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "NSSet+Organizer.h"

@implementation NSSet (Organizer)

- (NSArray *)albumsSortedByName {
    return [[self allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (NSArray *)songsSortedByTrackNumber {
    return [[self allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"trackNumber" ascending:YES]]];
}

@end
