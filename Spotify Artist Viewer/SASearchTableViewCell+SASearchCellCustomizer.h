//
//  SASearchTableViewCell+SASearchCellCustomizer.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchTableViewCell.h"
#import "SAArtist.h"

@interface SASearchTableViewCell (SASearchCellCustomizer)

- (void)customizeCellWithArtist:(SAArtist *)artist;

@end
