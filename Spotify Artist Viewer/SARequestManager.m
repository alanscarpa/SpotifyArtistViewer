//
//  SARequestManager.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"

@implementation SARequestManager

+(instancetype)sharedManager
{
    static SARequestManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[SARequestManager alloc]init];
    });
    return _sharedManager;
}


-(void)getArtistsWithQuery:(NSString*)query
                   success:(void (^)(NSDictionary *artists))success
                   failure:(void (^)(NSError *error))failure
{
    NSURLSession *urlSession = [NSURLSession sharedSession];
    query = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *getRequestString = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=%@&type=artist", query];
    NSURL *url = [NSURL URLWithString:getRequestString];
    NSURLSessionTask *apiCallTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            // Get artist bio
            //http://developer.echonest.com/api/v4/artist/biographies?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:4Z8W4fKeB5YxbusRsdQVPb
            
            // Get artist image url
            //http://developer.echonest.com/api/v4/artist/images?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:4Z8W4fKeB5YxbusRsdQVPb&format=json&results=1&start=0&license=unknown
            
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
           // NSLog(@"%@", jsonResponse);
            success(jsonResponse);
        } else {
            failure(error);
        }
    }];
    [apiCallTask resume];
}



-(void)getArtistInfoWithSpotifyID:(NSString*)spotifyID
                   success:(void (^)(NSDictionary *results))success
                   failure:(void (^)(NSError *error))failure
{
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSString *getRequestString = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/profile?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:%@&bucket=biographies&bucket=images", spotifyID];
    
    
    NSURL *url = [NSURL URLWithString:getRequestString];
    NSURLSessionTask *apiCallTask = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            
        // http://developer.echonest.com/api/v4/artist/profile?api_key=ZIJYLQIMEDOZIPP3C&id=spotify:artist:4Z8W4fKeB5YxbusRsdQVPb&bucket=biographies&bucket=images
            
        
            
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // NSLog(@"%@", jsonResponse);
            success(jsonResponse);
        } else {
            failure(error);
        }
    }];
    [apiCallTask resume];
}


@end
