//
//  SAInfiniteScrollHandler.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SASearchViewController.h"


@interface SAInfiniteScrollHandler : NSObject

@property (nonatomic) NSInteger offset;
- (void)setUpInfiniteScrollOnViewController:(UIViewController *)viewController withSearchLimit:(NSInteger)limit;

@end
