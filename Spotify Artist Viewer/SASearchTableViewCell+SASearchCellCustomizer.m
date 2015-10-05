//
//  SASearchTableViewCell+SASearchCellCustomizer.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchTableViewCell+SASearchCellCustomizer.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Genre.h"

@implementation SASearchTableViewCell (SASearchCellCustomizer)

- (void)customizeCellWithArtist:(Artist *)artist atIndexPath:(NSIndexPath *)indexPath {
    [self.activityIndicatorView startAnimating];
    self.favoriteButton.tag = indexPath.row;
    self.artistNameLabel.text = artist.name;
    [self setGenresOnArtist:artist];
    self.artistPopularityPercentageLabel.text = artist.popularity;
    [self.artistImageView sd_setImageWithURL:[NSURL URLWithString:artist.imageLocalURL]
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.activityIndicatorView stopAnimating];
                                   if (error){
                                       self.artistImageView.image = [UIImage imageNamed:@"noImage.jpg"];
                                   }
                               }];
}

- (void)setGenresOnArtist:(Artist *)artist {
    if (artist.genre.count > 0){
        NSMutableArray *allGenres = [[NSMutableArray alloc] init];
        for (Genre *genre in [artist.genre allObjects]){
            [allGenres addObject:genre.name];
        }
        self.artistGenresLabel.text = [allGenres componentsJoinedByString:@", "];
    } else {
        self.artistGenresLabel.text = nil;
        self.artistNameOffsetConstraint.constant = 0;
    }
}

@end
