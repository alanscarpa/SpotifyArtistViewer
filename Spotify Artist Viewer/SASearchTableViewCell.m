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
    self.artistImageView.layer.masksToBounds = YES;
    self.artistImageView.layer.cornerRadius = self.artistImageView.frame.size.height/2;
}

- (IBAction)didTapFavoritesButton:(id)sender {
    [self.delegate didTapFavoritesWithSearchTableViewCell:self];
}

@end
