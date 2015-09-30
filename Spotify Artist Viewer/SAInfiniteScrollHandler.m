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

- (void)setUpInfiniteScrollOnViewController:(UIViewController *)viewController withSearchLimit:(NSInteger)limit {
    __block SASearchViewController *vc = (SASearchViewController *)viewController;
    __block NSInteger offset = limit;
    vc.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    [vc.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        self.offset += offset;
        [vc searchForSpotifyArtistWithOffset:self.offset];
        [tableView finishInfiniteScroll];
    }];
}

@end
