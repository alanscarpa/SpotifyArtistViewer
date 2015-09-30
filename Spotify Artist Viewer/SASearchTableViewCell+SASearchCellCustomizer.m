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

- (void)customizeCellWithArtist:(SAArtist *)artist {
    [self.activityIndicator startAnimating];
    self.artistName.text = artist.artistName;
    self.artistGenres.text = [artist.genres componentsJoinedByString:@", "];
    if ([self.artistGenres.text isEqualToString:@""]){
        self.artistNameOffset.constant = 0;
    }
    self.artistPopularity.text = artist.popularity;
    [self.artistImage sd_setImageWithURL:artist.artistSearchThumbnailImageURL
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.activityIndicator stopAnimating];
                                   if (error){
                                       self.artistImage.image = [UIImage imageNamed:@"noImage.jpg"];
                                   }
                               }];
}

@end
