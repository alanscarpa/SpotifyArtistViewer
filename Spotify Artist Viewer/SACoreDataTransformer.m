//
//  SACoreDataTransformer.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SACoreDataTransformer.h"
#import "SADataStore.h"

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
    Artist *artistFromCoreData = [self artistFromCoreDataWithID:artistDictionary[@"id"]];
    if (!artistFromCoreData) {
        Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:ArtistEntityName inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
        [self setDetailsForArtist:artist FromDictionary:artistDictionary];
        return artist;
    } else {
        [self setDetailsForArtist:artistFromCoreData FromDictionary:artistDictionary];
        return artistFromCoreData;
    }
}

+ (Artist *)artistFromCoreDataWithID:(NSString *)spotifyID {
    NSArray *existingArtists = [self fetchExistingArtistsFromCoreData];
    if (existingArtists.count > 0) {
        for (int i = 0; i < existingArtists.count; i++) {
            if ([[existingArtists[i] spotifyID] isEqualToString:spotifyID]) {
                return existingArtists[i];
            }
        }
    }
    return nil;
}

+ (NSArray *)fetchExistingArtistsFromCoreData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ArtistEntityName];
    return [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
}

+ (void)setDetailsForArtist:(Artist *)artist FromDictionary:(NSDictionary *)artistDictionary {
    artist.name = artistDictionary[@"name"];
    artist.spotifyID = artistDictionary[@"id"];
    if ([artistDictionary[@"images"] count] > 0) {
        artist.imageLocalURL = [[NSURL URLWithString:artistDictionary[@"images"][0][@"url"]] absoluteString];
    }
    [self setGenres:artistDictionary[@"genres"] ForArtist:artist];
    artist.popularity = [NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]];
}

+ (void)setGenres:(NSArray *)genres ForArtist:(Artist *)artist {
    for (NSString *genreName in genres) {
        if (![self artist:artist HasGenreNamed:genreName]) {
            Genre *genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            genre.name = genreName;
            [artist addGenreObject:genre];
        }
    }
}

+ (BOOL)artist:(Artist *)artist HasGenreNamed:(NSString *)genreName {
    for (Genre *genre in artist.genre) {
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
    [[SADataStore sharedDataStore] save];
    return artistBio;
}

#pragma mark - Album Methods

+ (NSArray *)albumsFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist {
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        if (![self doesArtist:artist alreadyHaveAlbum:dictionary]) {
            Album *newAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            [self updateArtist:artist album:newAlbum fromDictionary:dictionary];
            [artist addAlbumObject:newAlbum];
        }
    }
    return [artist.album allObjects];
}

+ (BOOL)doesArtist:(Artist *)artist alreadyHaveAlbum:(NSDictionary *)dictionary {
    for (Album *album in [artist.album allObjects]) {
        if ([dictionary[@"id"] isEqualToString:album.spotifyID]) {
            [self updateArtist:artist album:album fromDictionary:dictionary];
            return YES;
        }
    }
    return NO;
}

+ (void)updateArtist:(Artist *)artist album:(Album *)album fromDictionary:(NSDictionary *)dictionary {
    album.name = dictionary[@"name"];
    album.spotifyID = dictionary[@"id"];
    if ([dictionary[@"images"] count]>0) {
        album.imageLocalURL = dictionary[@"images"][0][@"url"];
    }
}

#pragma mark - Song Methods

+ (NSArray *)songsFromDictionary:(NSDictionary *)JSONDictionary forAlbum:(Album *)album {
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        if (![self songOnAlbum:album existsInDictionary:dictionary]) {
            Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            [self updateSong:newSong withDetails:dictionary];
            [album addSongObject:newSong];
        }
    }
    return [album.song allObjects];
}

+ (BOOL)songOnAlbum:(Album *)album existsInDictionary:(NSDictionary *)dictionary {
    for (Song *song in album.song) {
        if ([song.spotifyID isEqualToString:dictionary[@"id"]]) {
            [self updateSong:song withDetails:dictionary];
            return YES;
        }
    }
    return NO;
}

+ (void)updateSong:(Song *)song withDetails:(NSDictionary *)dictionary {
    song.name = dictionary[@"name"];
    song.trackNumber = dictionary[@"track_number"];
    song.spotifyID = dictionary[@"id"];
}

+ (void)saveSongs:(NSArray *)songs fromAlbum:(Album *)album toCoreData:(SADataStore *)dataStore {
    for (Song *song in songs) {
        Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:dataStore.managedObjectContext];
        newSong.name = song.name;
        newSong.trackNumber = song.trackNumber;
        [album addSongObject:newSong];
    }
    [dataStore save];
}

@end
