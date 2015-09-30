//
//  SAAFNetworkingManager.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/29/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAAFNetworkingManager : NSObject

+ (void)sendGETRequestWithQuery:(NSString *)query withOffset:(NSInteger)offSet withCompletionHandler:(void (^)(NSArray *artists, NSError *error))completionHandler;

@end
