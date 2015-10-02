//
//  SAFavoritesTableViewCell.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesTableViewCell.h"
#import "SASavedDataHandler.h"

@implementation SAFavoritesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)customizeCellWithCoreDataArtist:(Artist *)artist {
    self.artistName.text = artist.name;
    if (artist.imageLocalURL) {
        self.artistImage.image = [SASavedDataHandler localImageWithArtist:artist];
    }
}


@end
