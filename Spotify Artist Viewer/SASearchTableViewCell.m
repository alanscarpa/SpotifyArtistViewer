//
//  SASearchTableViewCell.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/29/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchTableViewCell.h"
#import "SAArtist.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SASearchTableViewCell

- (void)awakeFromNib {
    [self makeArtistImageCircular];
}

- (void)makeArtistImageCircular {
    self.artistImage.layer.masksToBounds = YES;
    self.artistImage.layer.cornerRadius = self.artistImage.frame.size.height/2;
}

- (IBAction)didTapFavoritesButton:(id)sender {
    [self.delegate didTapFavoritesWithSearchTableViewCell:self];
}

@end
