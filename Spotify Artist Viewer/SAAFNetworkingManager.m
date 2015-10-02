//
//  SAAFNetworkingManager.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/29/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAAFNetworkingManager.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SAArtist.h"
#import "SAAlbum.h"

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

+ (void)getArtistAlbums:(NSString *)spotifyID withCompletionHandler:(void (^)(NSArray  *albums, NSError *error))completionHandler {
    if (completionHandler){
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/artists/%@/albums?album_type=album&market=ES", spotifyID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completionHandler([self albumsFromJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           // <#code#>
        }];
    }
    
}

+ (NSArray *)albumsFromJSONDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *albums = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in JSONDictionary[@"items"]){
        SAAlbum *newAlbum = [[SAAlbum alloc] init];
        newAlbum.title = dictionary[@"name"];
        newAlbum.spotifyID = dictionary[@"id"];
        [albums addObject:newAlbum];
    }
    return albums;
}

+ (NSArray *)artistsWithJSONDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc]init];
    for (NSDictionary *artistDictionary in JSONDictionary[@"artists"][@"items"]) {
        [artistsFromSearch addObject:[self artistFromDictionary:artistDictionary]];
    }
    return artistsFromSearch;
}

+ (SAArtist *)artistFromDictionary:(NSDictionary *)artistDictionary {
    NSString *artistName = [NSString stringWithFormat:@"%@", artistDictionary[@"name"]];
    NSString *spotifyID = [NSString stringWithFormat:@"%@", artistDictionary[@"id"]];
    NSURL *artistThumbnailURL = nil;
    if ([artistDictionary[@"images"] count] > 0){
        artistThumbnailURL = [NSURL URLWithString:artistDictionary[@"images"][0][@"url"]];
    }
    NSArray *artistGenres = [[NSArray alloc]initWithArray:artistDictionary[@"genres"]];
    NSString *popularity = [NSString stringWithFormat:@"%@%%", artistDictionary[@"popularity"]];
    SAArtist *artist = [[SAArtist alloc]initWithName:artistName biography:nil imageURL:nil artistSearchThumbnailURL:artistThumbnailURL genres:artistGenres popularity:popularity spotifyID:spotifyID];
    return artist;
}

@end
