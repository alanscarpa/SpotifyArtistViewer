
//
//  SACoreDataTransformer.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SACoreDataTransformer.h"
#import "SADataStore.h"
#import "Artist.h"
#import "Genre.h"
#import "Album.h"
#import "Song.h"

@implementation SACoreDataTransformer

#pragma mark - Artist Methods

+ (NSArray *)artistsFromDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc] init];
    for (NSDictionary *artistDictionary in JSONDictionary[@"artists"][@"items"]) {
        Artist *artist = [[SADataStore sharedDataStore] fetchArtistWithSpotifyID:artistDictionary[@"id"]];
        if (!artist){
            artist = [[SADataStore sharedDataStore] insertNewArtist];
        }
        artist.spotifyID = artistDictionary[@"id"];
        artist.name = artistDictionary[@"name"];
        artist.popularity = [NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]];
        if ([artistDictionary[@"images"] count] > 0) {
            artist.imageLocalURL = [[NSURL URLWithString:artistDictionary[@"images"][0][@"url"]] absoluteString];
        }
        if ([artistDictionary[@"genres"] count] > 0) {
            NSMutableSet *genreSet = [[NSMutableSet alloc] init];
            for (NSString *genreName in artistDictionary[@"genres"]){
                Genre *genre = [[SADataStore sharedDataStore] insertNewGenre];
                genre.name = genreName;
                [genreSet addObject:genre];
            }
            artist.genres = genreSet;
        }
        [artistsFromSearch addObject:artist];
    }
    return artistsFromSearch;
}

#pragma mark - Biography Methods

+ (NSString *)bioFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist {
    NSString *artistBio = @"No bio available";
    for (NSDictionary *bio in JSONDictionary[@"response"][@"artist"][@"biographies"]) {
        // Find the first full biography if there is one
        if ((NSUInteger)bio[@"truncated"] == 0) {
            artistBio = [NSString stringWithFormat:@"%@", bio[@"text"]];
            break;
        }
    }
    artist.biography = artistBio;
    return artistBio;
}

#pragma mark - Album Methods

+ (NSArray *)albumsFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist {
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        Album *album = [artist albumWithSpotifyID:dictionary[@"id"]];
        if (!album){
            album = [[SADataStore sharedDataStore] insertNewAlbum];
            [artist addAlbumsObject:album];
        }
        album.name = dictionary[@"name"];
        album.spotifyID = dictionary[@"id"];
        if ([dictionary[@"images"] count]>0) {
            album.imageLocalURL = dictionary[@"images"][0][@"url"];
        }
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
        song.name = dictionary[@"name"];
        song.trackNumber = dictionary[@"track_number"];
        song.spotifyID = dictionary[@"id"];
    }
    return [album songsSortedByTrackNumber];
}

@end
