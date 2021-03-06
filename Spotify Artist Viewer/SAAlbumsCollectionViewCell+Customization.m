//
//  SAAlbumsCollectionViewCell+Customization.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAAlbumsCollectionViewCell+Customization.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SAConstants.h"
#import "SALocalFileManager.h"

@implementation SAAlbumsCollectionViewCell (Customization)

- (void)customizeCellWithAlbum:(Album *)album {
    [self.activityIndicatorView startAnimating];
    self.albumTitleLabel.text = album.name;
    [self loadCachedImageForAlbum:album];
    [self loadLatestImageForAlbum:album];
}

- (void)loadCachedImageForAlbum:(Album *)album {
    UIImage *cachedImage = [SALocalFileManager fetchImageNamed:album.spotifyID];
    if (cachedImage) {
        self.albumCoverImageView.image = cachedImage;
    }
}

- (void)loadLatestImageForAlbum:(Album *)album {
    [self.albumCoverImageView sd_setImageWithURL:[NSURL URLWithString:album.imageURLString]
                                placeholderImage:nil
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           [self.activityIndicatorView stopAnimating];
                                           if (error) {
                                               self.albumCoverImageView.image = [UIImage imageNamed:kNoImagePhotoName];
                                           }
                                       }];
}

@end
