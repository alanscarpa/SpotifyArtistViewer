//
//  SAArtist.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@implementation SAArtist

-(instancetype)init
{
    self = [self initWithName:@"" biography:@"" image:nil];
    return self;
}

-(instancetype)initWithName:(NSString*)name biography:(NSString*)bio image:(UIImage*)image
{
    self = [super init];
    if (self)
    {
        _artistName = name;
        _artistBiography = bio;
        _artistImage = image;
    }
    return self;
    
}


@end
