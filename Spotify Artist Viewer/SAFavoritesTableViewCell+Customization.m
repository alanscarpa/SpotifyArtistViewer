//
//  SAFavoritesTableViewCell+Customization.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/7/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesTableViewCell+Customization.h"
#import "SADataStore.h"

@implementation SAFavoritesTableViewCell (Customization)

- (void)customizeCellWithArtist:(Artist *)artist {
    self.artistNameLabel.text = artist.name;
    if (artist.imageLocalURL) {
        self.artistImageView.image = [[SADataStore sharedDataStore] fetchLocalImageWithArtist:artist];
    }
}

@end
