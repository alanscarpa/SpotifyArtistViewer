//
//  SASongsTableViewCell.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASongsTableViewCell.h"

@implementation SASongsTableViewCell

- (void)customizeCellWithCoreDataAlbum:(Album *)album {
    self.trackNumberLabel.text = @"1)";
    self.songNameLabel.text = album.name;
}

@end
