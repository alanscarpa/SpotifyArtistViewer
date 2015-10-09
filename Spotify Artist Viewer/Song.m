//
//  Song.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "Song.h"
#import "Album.h"

NSString *const kSongEntityName = @"Song";

@implementation Song

- (void)setDetailsWithDictionary:(NSDictionary *)details {
    self.name = details[@"name"];
    self.trackNumber = details[@"track_number"];
    self.spotifyID = details[@"id"];
}

@end
