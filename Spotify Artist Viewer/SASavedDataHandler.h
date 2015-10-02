//
//  SASavedDataHandler.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SADataStore.h"
#import "SAArtist.h"

@interface SASavedDataHandler : NSObject

+ (void)addArtist:(SAArtist *)artist andImage:(UIImage *)image toFavorites:(SADataStore *)dataStore;

@end
