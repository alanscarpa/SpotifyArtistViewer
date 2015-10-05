//
//  SASongsTableViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface SASongsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
- (void)customizeCellWithCoreDataAlbum:(Album *)album;

@end
