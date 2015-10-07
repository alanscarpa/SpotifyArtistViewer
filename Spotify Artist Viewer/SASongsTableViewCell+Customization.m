//
//  SASongsTableViewCell+Customization.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASongsTableViewCell+Customization.h"

@implementation SASongsTableViewCell (Customization)

- (void)customizeCellWithCoreDataSong:(Song *)song {
    self.trackNumberLabel.text = [NSString stringWithFormat:@"%@) ", [song.trackNumber stringValue]];
    self.songNameLabel.text = song.name;
}

@end
