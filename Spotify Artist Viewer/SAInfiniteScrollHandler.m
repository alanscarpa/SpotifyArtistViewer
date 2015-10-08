//
//  SAInfiniteScrollHandler.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAInfiniteScrollHandler.h"
#import <UIScrollView+InfiniteScroll.h>

@implementation SAInfiniteScrollHandler

- (void)addInfiniteScrollOnScrollView:(UIScrollView *)scrollView {
    scrollView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    [scrollView addInfiniteScrollWithHandler:^(UIScrollView *innerScrollView) {
        [self.delegate requestAdditionalIemsWithScrollHandler:self];
        [innerScrollView finishInfiniteScroll];
    }];
}

@end
