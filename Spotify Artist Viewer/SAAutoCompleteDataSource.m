//
//  SAAutoCompleteDataSource.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/13/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAAutoCompleteDataSource.h"
#import "SADataStore.h"

@implementation SAAutoCompleteDataSource

#pragma mark - MLPAutoCompleteTextField DataSource

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        handler([[SADataStore sharedDataStore] fetchAllArtists]);
    });
}

@end
