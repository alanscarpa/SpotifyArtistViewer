//
//  SASearchCollectionViewCell+SASearchCollectionViewCellCustomizer.m
//  
//
//  Created by Alan Scarpa on 10/1/15.
//
//

#import "SASearchCollectionViewCell+Customization.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SAConstants.h"

@implementation SASearchCollectionViewCell (Customization)

- (void)customizeCellWithArtist:(Artist *)artist {
    [self.activityIndicatorView startAnimating];
    self.artistNameLabel.text = artist.name;
    [self setStyleBasedOnPopularity:[artist.popularity floatValue]];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:artist.imageLocalURL]
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.activityIndicatorView stopAnimating];
                                   if (error) {
                                       self.profileImageView.image = [UIImage imageNamed:kNoImagePhotoName];
                                   }
                               }];
}

- (void)setStyleBasedOnPopularity:(CGFloat)popularity {
    CGFloat colorBasedOnPopularity = (110 - popularity) / 255.0f;
    // If popularity is greater than 80%, then we give full alpha.
    CGFloat alphaBasedOnPopularity = popularity / 80;
    // We don't want very unpopular artists to become invisible, so we set a minimum
    if (alphaBasedOnPopularity < 0.25) {
        alphaBasedOnPopularity = 0.25;
    }
    self.backgroundColor = [UIColor colorWithRed:colorBasedOnPopularity green:colorBasedOnPopularity blue:colorBasedOnPopularity alpha:1.0];
    self.profileImageView.alpha = alphaBasedOnPopularity;
    self.artistNameLabel.alpha = alphaBasedOnPopularity;
}

@end
