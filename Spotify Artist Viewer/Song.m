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


- (void)setDetailsWithName:(NSString *)name spotifyID:(NSString *)spotifyID andTrackNumber:(NSNumber *)trackNumber {
    self.name = name;
    self.spotifyID = spotifyID;
    self.trackNumber = trackNumber;
}

@end
