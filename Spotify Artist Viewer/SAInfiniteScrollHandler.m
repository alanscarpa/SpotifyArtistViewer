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

- (void)setUpInfiniteScrollOnViewController:(UIViewController *)viewController {
    __block SASearchViewController *vc = (SASearchViewController *)viewController;
    vc.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    [vc.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        self.offset += 3;
        [vc searchForSpotifyArtistWithOffset:self.offset];
        [tableView finishInfiniteScroll];
    }];
}

- (instancetype)init{
    self = [super init];
    if (self)
    {
        _offset = 0;
    }
    return self;
}

@end
