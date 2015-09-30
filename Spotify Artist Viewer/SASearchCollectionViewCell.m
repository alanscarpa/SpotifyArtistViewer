//
//  SASearchCollectionViewCell.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchCollectionViewCell.h"
#import <PureLayout/PureLayout.h>

@interface SASearchCollectionViewCell ()
@property (nonatomic, strong) NSArray *views;
@end

@implementation SASearchCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect) frame{
    self = [super initWithFrame:frame];
    if (self){
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor blueColor];
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _profileImage = [[UIImageView alloc] init];
    _profileImage.backgroundColor = [UIColor blackColor];
    _artistName = [[UILabel alloc] init];
    _artistGenres = [[UILabel alloc] init];
    _artistPopularity = [[UILabel alloc] init];
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    
    self.views = @[_profileImage, _artistName, _artistGenres, _artistPopularity, _activityIndicator];
    [self addViewsToCell];
    [self constrainCellViews];
}

- (void)addViewsToCell {
    for (UIView *view in self.views){
        [self addSubview:view];
    }
}

- (void)constrainCellViews {
//    [_profileImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:16];
//    [_profileImage autoCenterInSuperview];
    [_artistName autoPinEdgesToSuperviewMargins];
}

@end
