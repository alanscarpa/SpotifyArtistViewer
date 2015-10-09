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

NSString *const _Nonnull kArtistEntityName = @"Artist";

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

- (void)setDetailsWithDictionary:(NSDictionary *)details {
    self.spotifyID = details[@"id"];
    self.name = details[@"name"];
    self.popularity = [NSString stringWithFormat:@"%@%%", details[@"popularity"]];
    
    if ([details[@"images"] count] > 0) {
        self.imageLocalURL = [[NSURL URLWithString:details[@"images"][0][@"url"]] absoluteString];
    }
    
    if ([details[@"genres"] count] > 0) {
        NSMutableSet *genreSet = [[NSMutableSet alloc] init];
        for (NSString *genreName in details[@"genres"]){
            Genre *genre = [[SADataStore sharedDataStore] insertNewGenre];
            genre.name = genreName;
            [genreSet addObject:genre];
        }
        self.genres = genreSet;
    }
}


@end
