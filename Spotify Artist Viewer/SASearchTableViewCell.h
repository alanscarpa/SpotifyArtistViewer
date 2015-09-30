//
//  SASearchTableViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/29/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *artistGenres;
@property (weak, nonatomic) IBOutlet UILabel *artistPopularity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
