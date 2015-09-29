//
//  SARequestManager.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"

@implementation SARequestManager

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (void)getArtistsWithQuery:(NSString*)query
                   success:(void (^)(NSDictionary *artists))success
                   failure:(void (^)(NSError *error))failure {
    NSURLSessionTask *apiCallTask = [[NSURLSession sharedSession] dataTaskWithURL:[self createSpotifyGETRequestURLWithQuery:query] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (success) {
                    success(jsonResponse);
                }
                
            }];
        } else {
            failure(error);
        }
    }];
    [apiCallTask resume];
}

- (void)getArtistInfoWithSpotifyID:(NSString*)spotifyID
                   success:(void (^)(NSDictionary *results))success
                   failure:(void (^)(NSError *error))failure {
    NSURLSessionTask *apiCallTask = [[NSURLSession sharedSession] dataTaskWithURL:[self createEchoNestGETRequestURLWithSpotifyID:spotifyID] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            success(jsonResponse);
        } else {
            failure(error);
        }
    }];
    [apiCallTask resume];
}

- (NSURL *)createSpotifyGETRequestURLWithQuery:(NSString *)query {
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *getRequestString = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=artist", query];
    return [NSURL URLWithString:getRequestString];
}

- (NSURL *)createEchoNestGETRequestURLWithSpotifyID:(NSString *)spotifyID {
    NSString *getRequestString = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/profile?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:%@&bucket=biographies&bucket=images", spotifyID];
    return [NSURL URLWithString:getRequestString];
}

@end
