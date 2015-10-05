//
//  SASongsTableViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SASongsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
- (void)customizeCellWithCoreDataSong:(Song *)song;

@end
