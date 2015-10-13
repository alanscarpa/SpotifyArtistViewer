//
//  SAFavoritesTableViewCell+Customization.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesTableViewCell+Customization.h"
#import "SADataStore.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SAConstants.h"
#import "SALocalFileManager.h"

@implementation SAFavoritesTableViewCell (Customization)

- (void)customizeCellWithArtist:(Artist *)artist {
    self.artistNameLabel.text = artist.name;
    [self loadCachedImageForArtist:artist];
    [self loadLatestImageForArtist:artist];
}

- (void)loadCachedImageForArtist:(Artist *)artist {
    UIImage *cachedImage = [SALocalFileManager fetchImageNamed:artist.spotifyID];
    if (cachedImage) {
        self.artistImageView.image = cachedImage;
    }
}

- (void)loadLatestImageForArtist:(Artist *)artist {
    [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:artist.imageURLString]
                            placeholderImage:nil
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       if (error) {
                                           self.artistImageView.image = [UIImage imageNamed:kNoImagePhotoName];
                                       }
                                   }];
}

@end
