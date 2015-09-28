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
    NSURLSession *urlSession = [NSURLSession sharedSession];
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *getRequestString = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=artist", query];
    NSURL *url = [NSURL URLWithString:getRequestString];
    NSURLSessionTask *apiCallTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            success(jsonResponse);
        } else {
            failure(error);
        }
    }];
    [apiCallTask resume];
}

- (void)getArtistInfoWithSpotifyID:(NSString*)spotifyID
                   success:(void (^)(NSDictionary *results))success
                   failure:(void (^)(NSError *error))failure {
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSString *getRequestString = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/profile?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:%@&bucket=biographies&bucket=images", spotifyID];
    NSURL *url = [NSURL URLWithString:getRequestString];
    NSURLSessionTask *apiCallTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            success(jsonResponse);
        } else {
            failure(error);
        }
    }];
    [apiCallTask resume];
}


@end
