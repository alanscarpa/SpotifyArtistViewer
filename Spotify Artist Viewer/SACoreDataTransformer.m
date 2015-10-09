
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
        [artistsFromSearch addObject:[SACoreDataTransformer artistFromDictionary:artistDictionary]];
    }
    return artistsFromSearch;
}

+ (Artist *)artistFromDictionary:(NSDictionary *)artistDictionary {
    Artist *artistFromCoreData = [[SADataStore sharedDataStore] fetchArtistWithSpotifyID:artistDictionary[@"id"]];
    if (!artistFromCoreData) {
        Artist *artist = [[SADataStore sharedDataStore] insertNewArtistWithSpotifyID:artistDictionary[@"id"]];
        [self updateDetailsForArtist:artist FromDictionary:artistDictionary];
        return artist;
    } else {
        [self updateDetailsForArtist:artistFromCoreData FromDictionary:artistDictionary];
        return artistFromCoreData;
    }
}

+ (void)updateDetailsForArtist:(Artist *)artist FromDictionary:(NSDictionary *)artistDictionary {
    artist.name = artistDictionary[@"name"];
    artist.spotifyID = artistDictionary[@"id"];
    if ([artistDictionary[@"images"] count] > 0) {
        artist.imageLocalURL = [[NSURL URLWithString:artistDictionary[@"images"][0][@"url"]] absoluteString];
    }
    artist.popularity = [NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]];
    [self setGenres:artistDictionary[@"genres"] ForArtist:artist];
}

+ (void)setGenres:(NSArray *)genres ForArtist:(Artist *)artist {
    for (NSString *genreName in genres) {
        if (![self artist:artist HasGenreNamed:genreName]) {
            Genre *genre = [[SADataStore sharedDataStore] insertNewGenre];
            genre.name = genreName;
            [artist addGenresObject:genre];
        }
    }
}

+ (BOOL)artist:(Artist *)artist HasGenreNamed:(NSString *)genreName {
    for (Genre *genre in artist.genres) {
        if ([genre.name isEqualToString:genreName]) {
            return YES;
        }
    }
    return NO;
}

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
        if (![self doesArtist:artist alreadyHaveAlbum:dictionary]) {
            Album *newAlbum = [[SADataStore sharedDataStore] insertNewAlbum];
            [self updateArtist:artist withAlbum:newAlbum fromDictionary:dictionary];
            [artist addAlbumsObject:newAlbum];
        }
    }
    return [artist albumsSortedByName];
}

+ (BOOL)doesArtist:(Artist *)artist alreadyHaveAlbum:(NSDictionary *)dictionary {
    for (Album *album in [artist.albums allObjects]) {
        if ([dictionary[@"id"] isEqualToString:album.spotifyID]) {
            [self updateArtist:artist withAlbum:album fromDictionary:dictionary];
            return YES;
        }
    }
    return NO;
}

+ (void)updateArtist:(Artist *)artist withAlbum:(Album *)album fromDictionary:(NSDictionary *)dictionary {
    album.name = dictionary[@"name"];
    album.spotifyID = dictionary[@"id"];
    if ([dictionary[@"images"] count]>0) {
        album.imageLocalURL = dictionary[@"images"][0][@"url"];
    }
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
