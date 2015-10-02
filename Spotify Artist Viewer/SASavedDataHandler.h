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
#import "Artist.h"

@interface SASavedDataHandler : NSObject

+ (void)addArtist:(SAArtist *)artist toFavorites:(SADataStore *)dataStore;
+ (UIImage *)localImageWithArtist:(Artist *)artist;

@end
