//
//  SAFavoritesTableViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAFavoritesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistName;

@end
