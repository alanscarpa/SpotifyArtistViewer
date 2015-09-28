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
@property (nonatomic, strong) UIImage *artistImage;

-(instancetype)initWithName:(NSString*)name
                  biography:(NSString*)bio
                      image:(UIImage*)image;

@end
