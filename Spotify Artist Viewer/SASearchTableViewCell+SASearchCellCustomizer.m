//
//  SASearchTableViewCell+SASearchCellCustomizer.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchTableViewCell+SASearchCellCustomizer.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SASearchTableViewCell (SASearchCellCustomizer)

- (void)customizeCellWithArtist:(SAArtist *)artist atIndexPath:(NSIndexPath *)indexPath {
    [self.activityIndicatorView startAnimating];
    self.favoriteButton.tag = indexPath.row;
    self.artistNameLabel.text = artist.artistName;
    self.artistGenresLabel.text = [artist.genres componentsJoinedByString:@", "];
    if ([self.artistGenresLabel.text isEqualToString:@""]){
        self.artistNameOffsetConstraint.constant = 0;
    }
    self.artistPopularityPercentageLabel.text = artist.popularity;
    [self.artistImageView sd_setImageWithURL:artist.artistSearchThumbnailImageURL
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.activityIndicatorView stopAnimating];
                                   if (error){
                                       self.artistImageView.image = [UIImage imageNamed:@"noImage.jpg"];
                                   }
                               }];
}

@end
