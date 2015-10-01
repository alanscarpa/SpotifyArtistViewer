//
//  SASearchCollectionViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASearchCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *artistName;
@property (strong, nonatomic) UILabel *artistPopularity;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
