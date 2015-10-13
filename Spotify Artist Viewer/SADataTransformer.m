
//
//  SACoreDataTransformer.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SADataTransformer.h"
#import "SADataStore.h"
#import "Artist.h"
#import "Genre.h"
#import "Album.h"
#import "Song.h"
#import "SAConstants.h"
#import "SALocalFileManager.h"

@implementation SADataTransformer

#pragma mark - Artist Methods

+ (NSArray *)artistsFromDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc] init];
    for (NSDictionary *artistDictionary in JSONDictionary[@"artists"][@"items"]) {
        Artist *artist = [[SADataStore sharedDataStore] fetchArtistWithSpotifyID:artistDictionary[@"id"]];
        if (!artist) {
            artist = [[SADataStore sharedDataStore] insertNewArtist];
        }
        [artist setDetailsWithName:artistDictionary[@"name"]
                         spotifyID:artistDictionary[@"id"]
                    imageURLString:[self imageURLFromDictionary:artistDictionary]
                        popularity:[NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]]
                            genres:[self genresFromDictionary:artistDictionary]];
        [SALocalFileManager saveImage:artist.imageURLString withName:artist.spotifyID];
        [artistsFromSearch addObject:artist];
    }
    return artistsFromSearch;
}

#pragma mark - Album Methods

+ (NSArray *)albumsFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist {
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        Album *album = [artist albumWithSpotifyID:dictionary[@"id"]];
        if (!album) {
            album = [[SADataStore sharedDataStore] insertNewAlbum];
            [artist addAlbumsObject:album];
        }
        [album setDetailsWithName:dictionary[@"name"] spotifyID:dictionary[@"id"] andImageURLString:[self imageURLFromDictionary:dictionary]];
    }
    return [artist albumsSortedByName];
}

#pragma mark - Song Methods

+ (NSArray *)songsFromDictionary:(NSDictionary *)JSONDictionary forAlbum:(Album *)album {
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        Song *song = [album songWithSpotifyID:dictionary[@"id"]];
        if (!song) {
            song = [[SADataStore sharedDataStore] insertNewSong];
            [album addSongsObject:song];
        }
        [song setDetailsWithName:dictionary[@"name"] spotifyID:dictionary[@"id"] andTrackNumber:dictionary[@"track_number"]];
    }
    return [album songsSortedByTrackNumber];
}

#pragma mark - Biography Methods

+ (NSString *)bioFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist {
    NSString *artistBio = [self biographyFromDictionary:JSONDictionary];
    artist.biography = artistBio;
    return artistBio;
}

#pragma mark - Helper Methods

+ (NSString *)imageURLFromDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"images"] count] > 0) {
        return [[NSURL URLWithString:dictionary[@"images"][0][@"url"]] absoluteString];
    } else {
        return nil;
    }
}

+ (NSSet *)genresFromDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"genres"] count] > 0) {
        NSMutableSet *genreSet = [[NSMutableSet alloc] init];
        for (NSString *genreName in dictionary[@"genres"]) {
            Genre *genre = [[SADataStore sharedDataStore] insertNewGenre];
            genre.name = genreName;
            [genreSet addObject:genre];
        }
        return genreSet;
    } else {
        return nil;
    }
}

+ (void)saveImageToLocalFileDirectory:(NSString *)imageURLString forArtist:(Artist *)artist {
    
}

+ (NSString *)biographyFromDictionary:(NSDictionary *)dictionary {
    NSString *artistBio = kNoBioAvailableText;
    for (NSDictionary *bio in dictionary[@"response"][@"artist"][@"biographies"]) {
        // Find the first full biography if there is one
        if ((NSUInteger)bio[@"truncated"] == 0) {
            artistBio = [NSString stringWithFormat:@"%@", bio[@"text"]];
            break;
        }
    }
    return artistBio;
}

@end
