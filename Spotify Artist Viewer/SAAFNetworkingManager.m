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

+ (void)sendGETRequestWithQuery:(NSString *)query withReturnLimit:(NSInteger)limit withOffset:(NSInteger)offset withCompletionHandler:(void (^)(NSArray  *artists, NSError *error))completionHandler {
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
            completionHandler([self albumsFromJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
    
}

+ (void)getAlbumSongs:(NSString *)albumSpotifyID withCompletionHandler:(void (^)(NSArray *songs, NSError *error))completionHandler {
    if (completionHandler){
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/albums/%@/tracks?market=ES", albumSpotifyID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self songsFromJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
}

#pragma mark - Helper Methods

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

+ (NSArray *)songsFromJSONDictionary:(NSDictionary *)JSONDictionary {
      NSMutableArray *songs = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in JSONDictionary[@"items"]){
        Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
        newSong.name = dictionary[@"name"];
        newSong.trackNumber = dictionary[@"track_number"];
        [songs addObject:newSong];
    }
      return songs;
}

+ (NSArray *)albumsFromJSONDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *albums = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in JSONDictionary[@"items"]){
        Album *newAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
        newAlbum.name = dictionary[@"name"];
        newAlbum.spotifyID = dictionary[@"id"];
        if ([dictionary[@"images"] count]>0){
            newAlbum.imageLocalURL = dictionary[@"images"][0][@"url"];
        }
        [albums addObject:newAlbum];
    }
    [[SADataStore sharedDataStore] save];
    return albums;
}

+ (NSArray *)artistsWithJSONDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc]init];
    for (NSDictionary *artistDictionary in JSONDictionary[@"artists"][@"items"]) {
        [artistsFromSearch addObject:[self artistFromDictionary:artistDictionary]];
    }
    return artistsFromSearch;
}

+ (Artist *)artistFromDictionary:(NSDictionary *)artistDictionary {
    NSString *artistName = [NSString stringWithFormat:@"%@", artistDictionary[@"name"]];
    NSString *spotifyID = [NSString stringWithFormat:@"%@", artistDictionary[@"id"]];
    NSURL *artistThumbnailURL = nil;
    if ([artistDictionary[@"images"] count] > 0){
        artistThumbnailURL = [NSURL URLWithString:artistDictionary[@"images"][0][@"url"]];
    }
    NSArray *artistGenres = [[NSArray alloc]initWithArray:artistDictionary[@"genres"]];
    NSString *popularity = [NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]];
    Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
    artist.name = artistName;
    artist.spotifyID = spotifyID;
    artist.imageLocalURL = [artistThumbnailURL absoluteString];
    for (NSString *genreName in artistGenres){
        Genre *genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:[SADataStore sharedDataStore].managedObjectContext];
        genre.name = genreName;
        [artist addGenreObject:genre];
    }
    artist.popularity = popularity;
    return artist;
}

@end
