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
            NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
           // NSLog(@"%@", jsonResponse);
            success(jsonResponse);
        } else {
            failure(error);
        }
    }];
    [apiCallTask resume];
}

@end
