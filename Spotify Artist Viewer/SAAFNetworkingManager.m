//
//  SAAFNetworkingManager.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/29/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAAFNetworkingManager.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "Song.h"
#import "Artist.h"
#import "Genre.h"
#import "SADataStore.h"

@implementation SAAFNetworkingManager

+ (void)searchForArtistsWithQuery:(NSString *)query withReturnLimit:(NSInteger)limit withOffset:(NSInteger)offset withCompletionHandler:(void (^)(NSArray  *artists, NSError *error))completionHandler {
    if (completionHandler){
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=artist&limit=%lu&offset=%lu", query, (long)limit, (long)offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionHandler([self artistsWithJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            completionHandler(nil, error);
        }];
    }
    
}

+ (void)getArtistBiography:(NSString *)spotifyID withCompletionHandler:(void (^)(NSString *artistBio, NSError *error))completionHandler {
    if (completionHandler){
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/profile?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:%@&bucket=biographies", spotifyID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self artistBioFromJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
    
}

+ (void)getArtistAlbums:(NSString *)spotifyID withCompletionHandler:(void (^)(NSArray  *albums, NSError *error))completionHandler {
    if (completionHandler){
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/artists/%@/albums?album_type=album&market=ES", spotifyID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self albumsFromJSONDictionary:responseObject withArtistSpotifyID:spotifyID], nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
    
}

+ (void)getAlbumSongs:(NSString *)albumSpotifyID withCompletionHandler:(void (^)(NSArray *songs, NSError *error))completionHandler {
    if (completionHandler){
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/albums/%@/tracks?market=ES", albumSpotifyID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self songsFromJSONDictionary:responseObject withAlbumSpotifyID:albumSpotifyID], nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
}

#pragma mark - Helper Methods

+ (NSArray *)artistsWithJSONDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc]init];
    for (NSDictionary *artistDictionary in JSONDictionary[@"artists"][@"items"]) {
        [artistsFromSearch addObject:[self artistFromDictionary:artistDictionary]];
    }
    return artistsFromSearch;
}

+ (Artist *)artistFromDictionary:(NSDictionary *)artistDictionary {
    Artist *artistFromCoreData = [self artistFromCoreDataWithID:artistDictionary[@"id"]];
    if (!artistFromCoreData){
        Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
        [self setDetailsForArtist:artist FromDictionary:artistDictionary];
        return artist;
    } else {
        [self setDetailsForArtist:artistFromCoreData FromDictionary:artistDictionary];
        return artistFromCoreData;
    }
}

+ (Artist *)artistFromCoreDataWithID:(NSString *)spotifyID {
    NSArray *existingArtists = [self fetchExistingArtistsFromCoreData];
    if (existingArtists.count > 0){
        for (int i = 0; i < existingArtists.count; i++) {
            if ([[existingArtists[i] spotifyID] isEqualToString:spotifyID]){
                return existingArtists[i];
            }
        }
    }
    return nil;
}

+ (NSArray *)fetchExistingArtistsFromCoreData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    return [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
}

+ (void)setDetailsForArtist:(Artist *)artist FromDictionary:(NSDictionary *)artistDictionary {
    artist.name = artistDictionary[@"name"];
    artist.spotifyID = artistDictionary[@"id"];
    if ([artistDictionary[@"images"] count] > 0){
        artist.imageLocalURL = [[NSURL URLWithString:artistDictionary[@"images"][0][@"url"]] absoluteString];
    }
    [self setGenres:artistDictionary[@"genres"] ForArtist:artist];
    artist.popularity = [NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]];
}

+ (void)setGenres:(NSArray *)genres ForArtist:(Artist *)artist {
    for (NSString *genreName in genres){
        if (![self artist:artist HasGenreNamed:genreName]){
            Genre *genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            genre.name = genreName;
            [artist addGenreObject:genre];
        }
    }
}

+ (BOOL)artist:(Artist *)artist HasGenreNamed:(NSString *)genreName {
    for (Genre *genre in artist.genre) {
        if ([genre.name isEqualToString:genreName]){
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)albumsFromJSONDictionary:(NSDictionary *)JSONDictionary withArtistSpotifyID:(NSString *)spotifyID {
    Artist *artist = [self fetchArtistWithSpotifyID:spotifyID];
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        if (![self doesArtist:artist alreadyHaveAlbum:dictionary]){
            Album *newAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            [self updateArtist:artist album:newAlbum fromDictionary:dictionary];
            [artist addAlbumObject:newAlbum];
        }
    }
    return [artist.album allObjects];
}

+ (Artist *)fetchArtistWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

+ (BOOL)doesArtist:(Artist *)artist alreadyHaveAlbum:(NSDictionary *)dictionary {
    for (Album *album in [artist.album allObjects]){
        if ([dictionary[@"id"] isEqualToString:album.spotifyID]){
            [self updateArtist:artist album:album fromDictionary:dictionary];
            return YES;
        }
    }
    return NO;
}

+ (void)updateArtist:(Artist *)artist album:(Album *)album fromDictionary:(NSDictionary *)dictionary {
    album.name = dictionary[@"name"];
    album.spotifyID = dictionary[@"id"];
    if ([dictionary[@"images"] count]>0){
        album.imageLocalURL = dictionary[@"images"][0][@"url"];
    }
}

+ (NSString *)artistBioFromJSONDictionary:(NSDictionary *)JSONDictionary {
    NSString *artistBio = @"No bio available";
    for (NSDictionary *bio in JSONDictionary[@"response"][@"artist"][@"biographies"]) {
        // Find the first full biography if there is one
        if ((NSUInteger)bio[@"truncated"] == 0) {
            artistBio = [NSString stringWithFormat:@"%@", bio[@"text"]];
            break;
        }
    }
    return artistBio;
}

+ (NSArray *)songsFromJSONDictionary:(NSDictionary *)JSONDictionary withAlbumSpotifyID:(NSString *)spotifyID {
    Album *album = [self fetchAlbumWithSpotifyID:spotifyID];
    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
        if (![self songOnAlbum:album existsInDictionary:dictionary]){
            Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
            [self updateSong:newSong withDetails:dictionary];
            [album addSongObject:newSong];
        }
    }
    return [album.song allObjects];
}

+ (Album *)fetchAlbumWithSpotifyID:(NSString *)spotifyID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"spotifyID == %@", spotifyID];
    request.predicate = predicate;
    return [[[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

+ (BOOL)songOnAlbum:(Album *)album existsInDictionary:(NSDictionary *)dictionary {
    for (Song *song in album.song) {
        if ([song.spotifyID isEqualToString:dictionary[@"id"]]){
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

@end
