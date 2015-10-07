//
//  SASongsTableViewCell.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASongsTableViewCell.h"

@implementation SASongsTableViewCell

- (void)customizeCellWithCoreDataSong:(Song *)song {
    self.trackNumberLabel.text = [NSString stringWithFormat:@"%@) ", [song.trackNumber stringValue]];
    self.songNameLabel.text = song.name;
}

@end
