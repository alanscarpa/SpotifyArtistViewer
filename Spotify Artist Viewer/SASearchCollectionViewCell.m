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
    [self decorateCell];
    [self initializeViews];
    [self addViewsToCell];
    [self constrainCellViews];
}

- (void)decorateCell {
    self.backgroundColor = [UIColor blueColor];
    self.layer.borderWidth = 2.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)initializeViews {
    _profileImage = [[UIImageView alloc] init];
    _profileImage.contentMode = UIViewContentModeScaleAspectFit;
    _profileImage.clipsToBounds = YES;
    
    _artistName = [[UILabel alloc] init];
    _artistName.textAlignment = NSTextAlignmentCenter;
    _artistGenres = [[UILabel alloc] init];
    _artistPopularity = [[UILabel alloc] init];
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
}

- (void)addViewsToCell {
    self.views = @[_profileImage, _artistName, _artistGenres, _artistPopularity, _activityIndicator];
    for (UIView *view in self.views){
        [self addSubview:view];
    }
}

- (void)constrainCellViews {
//    [_profileImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self withOffset:16];
//    [_profileImage autoCenterInSuperview];
    
    _profileImage.image = [UIImage imageNamed:@"corgi.jpg"];
    [_profileImage autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_profileImage autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:16.0];
    [_profileImage autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:8.0];
    [_profileImage autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-8.0];
    [_profileImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_artistName withOffset:-8.0];
    
    [_artistName autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-4.0];
    [_artistName autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_artistName autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:8.0];
    [_artistName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-8.0];
    _artistName.text = @"some artist";
}

@end
