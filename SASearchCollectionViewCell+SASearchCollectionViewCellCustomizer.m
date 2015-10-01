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
    self.artistName.text = artist.artistName;
    self.artistGenres.text = [artist.genres componentsJoinedByString:@", "];
//    if ([self.artistGenres.text isEqualToString:@""]){
//        self.artistNameOffset.constant = 0;
//    }
    self.artistPopularity.text = artist.popularity;
    [self.profileImage sd_setImageWithURL:artist.artistSearchThumbnailImageURL
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.activityIndicator stopAnimating];
                                   if (error){
                                       self.profileImage.image = [UIImage imageNamed:@"noImage.jpg"];
                                   }
                               }];
}

@end
