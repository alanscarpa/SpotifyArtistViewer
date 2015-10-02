//
//  SAFavoritesTableViewCell.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesTableViewCell.h"

@implementation SAFavoritesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)customizeCellWithCoreDataArtist:(Artist *)artist {
    self.artistName.text = artist.name;
    if (artist.imageLocalURL){
        self.artistImage.image = [UIImage imageWithContentsOfFile:[self photoLocationForArist:artist]];
    }
}

- (NSString *)photoLocationForArist:(Artist *)artist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/Photos/%@", documentsDirectory, artist.imageLocalURL];
}

@end
