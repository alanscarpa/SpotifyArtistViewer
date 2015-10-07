//
//  SASearchTableViewCell+SASearchCellCustomizer.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/30/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchTableViewCell.h"
#import "Artist.h"

@interface SASearchTableViewCell (SASearchCellCustomizer)

- (void)customizeCellWithArtist:(Artist *)artist atIndexPath:(NSIndexPath *)indexPath;

@end
