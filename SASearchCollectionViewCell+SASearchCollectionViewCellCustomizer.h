//
//  SASearchCollectionViewCell+SASearchCollectionViewCellCustomizer.h
//  
//
//  Created by Alan Scarpa on 10/1/15.
//
//

#import "SASearchCollectionViewCell.h"
#import "SAArtist.h"

@interface SASearchCollectionViewCell (SASearchCollectionViewCellCustomizer)
- (void)customizeCellWithArtist:(SAArtist *)artist;
@end
