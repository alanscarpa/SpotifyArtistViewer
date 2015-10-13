//
//  SALocalFileManager.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/13/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SALocalFileManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Artist.h"

@implementation SALocalFileManager

#pragma mark - Save Methods

+ (void)saveImage:(NSString *)imageURLString withName:(NSString *)imageName {
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:imageURLString]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                        // progression tracking code
                                                       }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                         if (image && finished) {
                                                             [self saveImage:image path:imageName];
                                                         }
     }];
}

+ (void)saveImage:(UIImage *)image path:(NSString *)fileNamePath {
    [self createPhotosDirectoryIfNecessary];
    [UIImagePNGRepresentation(image) writeToFile:[[self photosDirectory] stringByAppendingPathComponent:fileNamePath]
                                      atomically:YES];
}

#pragma mark - Fetch Methods

+ (UIImage *)fetchImageNamed:(NSString *)imageName {
    return [UIImage imageWithContentsOfFile:[[self photosDirectory] stringByAppendingPathComponent:imageName]];
}

#pragma mark - Helper Methods

+ (void)createPhotosDirectoryIfNecessary {
    NSError *error = nil;
    NSString *photosDirectory = [self photosDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:photosDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:photosDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:&error];
    }
}

+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)photosDirectory {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Photos"];
}

@end
