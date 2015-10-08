//
//  SAInfiniteScrollHandler.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol SAInfiniteScrollHandlerDelegate;

@interface SAInfiniteScrollHandler : NSObject

@property (nonatomic) NSInteger offset;
@property (nonatomic, weak) id<SAInfiniteScrollHandlerDelegate> delegate;
- (void)addInfiniteScrollOnScrollView:(UIScrollView *)scrollView;

@end

@protocol SAInfiniteScrollHandlerDelegate <NSObject>

- (void)requestAdditionalIemsWithScrollHandler:(SAInfiniteScrollHandler *)scrollHandler;

@end