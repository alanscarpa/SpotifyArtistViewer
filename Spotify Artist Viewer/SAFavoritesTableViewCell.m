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

    // Configure the view for the selected state
}

- (void)customizeCellWithCoreDataArtist:(Artist *)artist {
//    for (Artist *artist in savedArtists) {
//        NSLog(@"Name: %@", artist.name);
//        for (Album *albumm in artist.album){
//            NSLog(@"Albums: %@", albumm.name);
//            for (Song *songg in albumm.song){
//                NSLog(@"Songs: %@", songg.name);
//            }
//        }
//    };
    self.artistName.text = artist.name;
    if (artist.imageLocalURL){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *relativePathToImage = [NSString stringWithFormat:@"%@/Photos/%@", documentsDirectory, artist.imageLocalURL];
        self.artistImage.image = [UIImage imageWithContentsOfFile:relativePathToImage];
        NSLog(@"Image!");
    }
  
}

@end
