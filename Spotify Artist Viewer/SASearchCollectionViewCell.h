//
//  SASearchCollectionViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASearchCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
