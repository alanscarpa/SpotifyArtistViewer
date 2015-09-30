//
//  SASearchCollectionViewCell.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchCollectionViewCell.h"
#import <PureLayout/PureLayout.h>

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
    _profileImage = [[UIImage alloc]init];;
    _artistName = [[UILabel alloc]init];
    _artistGenres = [[UILabel alloc]init];
    _artistPopularity = [[UILabel alloc]init];
    _activityIndicator = [[UIActivityIndicatorView alloc]init];
    [self constrainCellViews];
}

- (void)constrainCellViews {
    
}
@end
