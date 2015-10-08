//
//  Artist.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "Artist.h"

NSString *const kArtistEntityName = @"Artist";

@implementation Artist

- (NSArray *)albumsSortedByName {
    return [[self.albums allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

@end
