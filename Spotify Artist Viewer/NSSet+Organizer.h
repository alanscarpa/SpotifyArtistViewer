//
//  NSSet+Organizer.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (Organizer)

- (NSArray *)albumsSortedByName;
- (NSArray *)songsSortedByTrackNumber;

@end
