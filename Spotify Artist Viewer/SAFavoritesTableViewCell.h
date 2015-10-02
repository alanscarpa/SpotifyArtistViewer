//
//  SAFavoritesTableViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"
#import "Album.h"
#import "Song.h"

@interface SAFavoritesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
- (void)customizeCellWithCoreDataArtist:(Artist *)artist;
@end
