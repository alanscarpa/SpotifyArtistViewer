//
//  SAArtist.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@implementation SAArtist

- (instancetype)init
{
    self = [self initWithName:@"" biography:@"" imageURL:nil artistSearchThumbnailURL:nil genres:nil popularity:@"" spotifyID:@""];
    return self;
}

- (instancetype)initWithName:(NSString *)name biography:(NSString *)bio imageURL:(NSURL *)imageURL artistSearchThumbnailURL:(NSURL *)thumbnailURL genres:(NSArray *)genres popularity:(NSString *)popularity spotifyID:(NSString *)spotifyID
{
    self = [super init];
    if (self)
    {
        _artistName = name;
        _artistBiography = bio;
        _artistImageURL = imageURL;
        _artistSearchThumbnailImageURL = thumbnailURL;
        _genres = genres;
        _popularity = popularity;
        _artistSpotifyID = spotifyID;
    }
    return self;
}

- (void)setBioFromJSON:(NSDictionary *)json {
    self.artistBiography = @"No bio available";
    for (NSDictionary *bio in json[@"response"][@"artist"][@"biographies"]) {
        // Find the first full biography if there is one
        if ((NSUInteger)bio[@"truncated"] == 0) {
            self.artistBiography = [NSString stringWithFormat:@"%@", bio[@"text"]];
            break;
        }
    }
}

- (void)setNameFromJSON:(NSDictionary *)json {
    self.artistName = json[@"response"][@"artist"][@"name"];
}

- (void)setImageURLFromJSON:(NSDictionary *)json {
    NSString *artistImageURL = [[NSString alloc]init];
    if ([json[@"response"][@"artist"][@"images"] count] > 0) {
        artistImageURL = [NSString stringWithFormat:@"%@", json[@"response"][@"artist"][@"images"][0][@"url"]];
    } else {
        artistImageURL = nil;
    }
    self.artistImageURL = [NSURL URLWithString:artistImageURL];
}

@end
