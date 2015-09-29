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

@implementation SAAFNetworkingManager

+ (void)sendGETRequestWithQuery:(NSString *)query withCompletionHandler:(void (^)(NSArray  *artists, NSError *error))completionHandler {
    if (completionHandler){
        query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [[AFHTTPRequestOperationManager manager] GET:[NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=artist", query] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionHandler([self artistsWithJSONDictionary:responseObject], nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            completionHandler(nil, error);
        }];
    }
    
}



+ (NSArray *)artistsWithJSONDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc]init];
    for (NSDictionary *artist in JSONDictionary[@"artists"][@"items"]) {
        NSString *artistName = [NSString stringWithFormat:@"%@", artist[@"name"]];
        NSString *spotifyID = [NSString stringWithFormat:@"%@", artist[@"id"]];
        NSURL *artistThumbnailURL = nil;
        if ([artist[@"images"] count] > 0){
             artistThumbnailURL = [NSURL URLWithString:artist[@"images"][0][@"url"]];
        }
        NSArray *artistGenres = [[NSArray alloc]initWithArray:artist[@"genres"]];
        NSString *popularity = [NSString stringWithFormat:@"%@", artist[@"popularity"]];
        SAArtist *artist = [[SAArtist alloc]initWithName:artistName biography:nil imageURL:nil artistSearchThumbnailURL:artistThumbnailURL genres:artistGenres popularity:popularity spotifyID:spotifyID];
        [artistsFromSearch addObject:artist];
    }
    return artistsFromSearch;
}

@end
