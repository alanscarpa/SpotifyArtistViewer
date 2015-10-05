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

- (void)setUpInfiniteScrollOnScrollView:(UIScrollView *)scrollView andCollectionView:(UICollectionView *)collectionView withSearchLimit:(NSInteger)limit {
    __block NSInteger offset = limit;
    scrollView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    collectionView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    
    [collectionView addInfiniteScrollWithHandler:^(UICollectionView* innerScrollView) {
        self.offset += offset;
        [self.delegate scrollHandler:self requestAdditionalItemsFromOffset:self.offset];
        [innerScrollView finishInfiniteScroll];
    }];
    
    [scrollView addInfiniteScrollWithHandler:^(UIScrollView* innerScrollView) {
        self.offset += offset;
        [self.delegate scrollHandler:self requestAdditionalItemsFromOffset:self.offset];
        [innerScrollView finishInfiniteScroll];
    }];
}

@end
