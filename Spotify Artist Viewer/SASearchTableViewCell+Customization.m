//
//  SASearchTableViewCell+SASearchCellCustomizer.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchTableViewCell+Customization.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Genre.h"
#import "SAConstants.h"
#import "SALocalFileManager.h"

@implementation SASearchTableViewCell (Customization)

- (void)customizeCellWithArtist:(Artist *)artist {
    [self.activityIndicatorView startAnimating];
    self.artistNameLabel.text = artist.name;
    [self setGenresOnArtist:artist];
    self.artistPopularityPercentageLabel.text = artist.popularity;
    [self loadCachedImageForArtist:artist];
    [self loadLatestImageForArtist:artist];
}

- (void)setGenresOnArtist:(Artist *)artist {
    if (artist.genres.count > 0) {
        NSMutableArray *allGenres = [[NSMutableArray alloc] init];
        for (Genre *genre in [artist.genres allObjects]) {
            [allGenres addObject:genre.name];
        }
        self.artistGenresLabel.text = [allGenres componentsJoinedByString:@", "];
    } else {
        self.artistGenresLabel.text = nil;
        self.artistNameOffsetConstraint.constant = 0;
    }
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
                                       [self.activityIndicatorView stopAnimating];
                                       if (error) {
                                           self.artistImageView.image = [UIImage imageNamed:kNoImagePhotoName];
                                       }
                                   }];
}

@end
