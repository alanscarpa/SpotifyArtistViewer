//
//  SALocalFileManager.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/13/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Artist;

@interface SALocalFileManager : NSObject

+ (void)saveImage:(NSString *)imageURLString withName:(NSString *)imageName;
+ (UIImage *)fetchImageNamed:(NSString *)imageName;

@end
