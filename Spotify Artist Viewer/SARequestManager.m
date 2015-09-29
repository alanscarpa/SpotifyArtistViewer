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

#pragma mark - Spotify Calls

- (void)sendDataTaskWithURL:(NSURL *)URL completionHandler:(void (^)(NSDictionary  * __nullable responseObject, NSError * __nullable error))completionHandler; {
    NSURLSessionTask *apiCallTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *resultError = nil;
        NSDictionary *jsonResponse = nil;
        if (data) {
            NSError *parseError = nil;
            jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            if (parseError) {
                resultError = parseError;
            }
        } else {
            resultError = error;
        }
        
        if (jsonResponse == nil) {
            if (resultError == nil) {
                resultError = [NSError errorWithDomain:@"TBD" code:0 userInfo:nil];
            }

        }
        completionHandler(jsonResponse, resultError);
    }];
    [apiCallTask resume];
}

- (void)getArtistsWithQuery:(NSString*)query
                   success:(void (^)(NSArray *artists))success
                   failure:(void (^)(NSError *error))failure {
    [self sendDataTaskWithURL:[self createSpotifyGETRequestURLWithQuery:query] completionHandler:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            NSArray *artists = [self artistsWithJSONDictionary:responseObject];
            if (success) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    success(artists);
                }];
            }
        } else {
            if (failure) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    failure(error);
                }];
            }
        }
    }];
}

#pragma mark - EchoNest Calls

- (void)getArtistInfoWithSpotifyID:(NSString*)spotifyID
                   success:(void (^)(SAArtist *artist))success
                   failure:(void (^)(NSError *error))failure {
    NSURLSessionTask *apiCallTask = [[NSURLSession sharedSession] dataTaskWithURL:[self createEchoNestGETRequestURLWithSpotifyID:spotifyID] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (success){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        success([self artistWithData:data]);
                    }];
            } else {
                NSLog(@"No success block called");
            }
        } else {
            if (failure){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    failure(error);
                }];
            } else {
                NSLog(@"Error but no failure block called");
            }
        }
    }];
    [apiCallTask resume];
}

#pragma mark - Helper Methods

- (NSURL *)createSpotifyGETRequestURLWithQuery:(NSString *)query {
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *getRequestString = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=artist", query];
    return [NSURL URLWithString:getRequestString];
}

- (NSURL *)createEchoNestGETRequestURLWithSpotifyID:(NSString *)spotifyID {
    NSString *getRequestString = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/profile?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:%@&bucket=biographies&bucket=images", spotifyID];
    return [NSURL URLWithString:getRequestString];
}

- (NSArray *)artistsWithJSONDictionary:(NSDictionary *)JSONDictionary {
    NSMutableArray *artistsFromSearch = [[NSMutableArray alloc]init];
    for (NSDictionary *artist in JSONDictionary[@"artists"][@"items"]) {
        NSString *artistName = [NSString stringWithFormat:@"%@", artist[@"name"]];
        NSString *spotifyID = [NSString stringWithFormat:@"%@", artist[@"id"]];
        SAArtist *artist = [[SAArtist alloc]initWithName:artistName biography:nil imageURL:nil spotifyID:spotifyID];
        [artistsFromSearch addObject:artist];
    }
    return artistsFromSearch;
}

- (SAArtist *)artistWithData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    SAArtist *artist = [[SAArtist alloc] init];
    if (jsonResponse){
        [artist setBioFromJSON:jsonResponse];
        [artist setNameFromJSON:jsonResponse];
        [artist setImageURLFromJSON:jsonResponse];
    } else {
        NSLog(@"Error serializing JSON from artist data.");
    }
    return artist;
}


@end
