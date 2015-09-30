//
//  SASearchViewController.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)searchForSpotifyArtistWithOffset:(NSInteger)offset;

@end
