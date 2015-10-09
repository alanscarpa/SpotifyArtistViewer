//
//  Artist.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SADataStore.h"
#import "Artist.h"
#import "Album.h"
#import "Song.h"
#import "Genre.h"

NSString *const kArtistEntityName = @"Artist";

@implementation Artist

- (Album *)albumWithSpotifyID:(NSString *)spotifyID {
    for (Album *album in self.albums) {
        if ([album.spotifyID isEqualToString:spotifyID]) {
            return album;
        }
    }
    return nil;
}

- (NSArray *)albumsSortedByName {
    return [[self.albums allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

@end
