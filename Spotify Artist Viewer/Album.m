//
//  Album.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "Album.h"
#import "Artist.h"
#import "Song.h"
#import "Genre.h"

NSString *const kAlbumEntityName = @"Album";

@implementation Album

- (Song *)songWithSpotifyID:(NSString *)spotifyID {
    for (Song *song in self.songs) {
        if ([song.spotifyID isEqualToString:spotifyID]) {
            return song;
        }
    }
    return nil;
}

- (NSArray *)songsSortedByTrackNumber {
    return [[self.songs allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"trackNumber" ascending:YES]]];
}

@end
