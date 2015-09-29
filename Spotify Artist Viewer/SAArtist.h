//
//  SAArtist.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SAArtist : NSObject

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artistBiography;
@property (nonatomic, strong) NSURL *artistImageURL;
@property (nonatomic, strong) NSString *artistSpotifyID;

- (instancetype)initWithName:(NSString*)name
                  biography:(NSString*)bio
                      imageURL:(NSURL*)imageURL
                  spotifyID:(NSString*)spotifyID;

- (void)setBioFromJSON:(NSDictionary *)json;
- (void)setNameFromJSON:(NSDictionary *)json;
- (void)setImageURLFromJSON:(NSDictionary *)json;
@end
