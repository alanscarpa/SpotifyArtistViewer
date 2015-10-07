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
#import "SADataStore.h"

@implementation SAAFNetworkingManager

+ (void)searchForArtistsWithQuery:(NSString *)query withReturnLimit:(NSInteger)limit withOffset:(NSInteger)offset withCompletionHandler:(void (^)(NSArray  *artists, NSError *error))completionHandler {
    if (completionHandler) {
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=artist&limit=%lu&offset=%lu", query, (long)limit, (long)offset] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionHandler([self artistsWithJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            completionHandler(nil, error);
        }];
    }
    
}

+ (void)getArtistAlbums:(NSString *)spotifyID withCompletionHandler:(void (^)(NSArray  *albums, NSError *error))completionHandler {
    if (completionHandler) {
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/artists/%@/albums?album_type=album&market=ES", spotifyID] parameters:nil success:^(AFHTTPRequestOperation *_Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self albumsFromJSONDictionary:responseObject withArtistSpotifyID:spotifyID], nil);
        } failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
    
}

+ (void)getAlbumSongs:(NSString *)albumSpotifyID withCompletionHandler:(void (^)(NSArray *songs, NSError *error))completionHandler {
    if (completionHandler) {
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/albums/%@/tracks?market=ES", albumSpotifyID] parameters:nil success:^(AFHTTPRequestOperation *_Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self songsFromJSONDictionary:responseObject withAlbumSpotifyID:albumSpotifyID], nil);
        } failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
}

+ (void)getArtistBiography:(NSString *)spotifyID withCompletionHandler:(void (^)(NSString *artistBio, NSError *error))completionHandler {
    if (completionHandler) {
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/profile?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:%@&bucket=biographies", spotifyID] parameters:nil success:^(AFHTTPRequestOperation *_Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self artistBioFromJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSLog(@"Error getting artist albums from spotify: %@", error);
        }];
    }
    
}

#pragma mark - Helper Methods

+ (NSArray *)artistsWithJSONDictionary:(NSDictionary *)JSONDictionary {    
    return [SADataStore artistsFromDictionary:JSONDictionary];
}

+ (NSArray *)albumsFromJSONDictionary:(NSDictionary *)JSONDictionary withArtistSpotifyID:(NSString *)spotifyID {
    return [SADataStore albumsFromDictionary:JSONDictionary forArtist:[SADataStore fetchArtistWithSpotifyID:spotifyID]];
}

+ (NSArray *)songsFromJSONDictionary:(NSDictionary *)JSONDictionary withAlbumSpotifyID:(NSString *)spotifyID {
    return [SADataStore songsFromDictionary:JSONDictionary forAlbum:[SADataStore fetchAlbumWithSpotifyID:spotifyID]];
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

@end
