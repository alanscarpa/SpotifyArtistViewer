//
//  SASearchTableViewCell.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/29/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SASearchTableViewCellDelegate;

@interface SASearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistGenresLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistPopularityPercentageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *artistNameOffsetConstraint;

@property (weak, nonatomic) id<SASearchTableViewCellDelegate> delegate;

@end

@protocol SASearchTableViewCellDelegate <NSObject>

- (void)didTapFavoritesWithSearchTableViewCell:(SASearchTableViewCell *)cell;

@end
