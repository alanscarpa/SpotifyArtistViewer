//
//  SASearchCollectionViewCell+SASearchCollectionViewCellCustomizer.m
//  
//
//  Created by Alan Scarpa on 10/1/15.
//
//

#import "SASearchCollectionViewCell+SASearchCollectionViewCellCustomizer.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SASearchCollectionViewCell (SASearchCollectionViewCellCustomizer)

- (void)customizeCellWithArtist:(SAArtist *)artist {
    [self.activityIndicator startAnimating];
    self.artistName.adjustsFontSizeToFitWidth = YES;
    self.artistName.minimumScaleFactor = 0.7;
    self.artistName.text = artist.artistName;
    self.artistPopularity.text = artist.popularity;
    [self setStyleBasedOnPopularity:[artist.popularity floatValue]];
    [self.profileImage sd_setImageWithURL:artist.artistSearchThumbnailImageURL
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.activityIndicator stopAnimating];
                                   if (error){
                                       self.profileImage.image = [UIImage imageNamed:@"noImage.jpg"];
                                   }
                               }];
}

- (void)setStyleBasedOnPopularity:(CGFloat)popularity {
    CGFloat colorBasedOnPopularity = (110 - popularity)/255.0f;
    // If popularity is greater than 80%, then we give full alpha.
    CGFloat alphaBasedOnPopularity = popularity/80;
    // We don't want very unpopular artists to become invisible, so we set a minimum
    if (alphaBasedOnPopularity < 0.25){
        alphaBasedOnPopularity = 0.25;
    }
    self.backgroundColor = [UIColor colorWithRed:colorBasedOnPopularity green:colorBasedOnPopularity blue:colorBasedOnPopularity alpha:1.0];
    self.profileImage.alpha = alphaBasedOnPopularity;
    self.artistName.alpha = alphaBasedOnPopularity;
}

@end
