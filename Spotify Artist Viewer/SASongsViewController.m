//
//  SASongsViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASongsViewController.h"
#import "SAAFNetworkingManager.h"
#import "SADataStore.h"
#import "SASongsTableViewCell.h"
#import "SASongsTableViewCell+Customization.h"

@interface SASongsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *songs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SASongsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerTableViewCell];
    [self loadCachedSongs];
    [self downloadLatestSongs];
}

- (void)registerTableViewCell {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SASongsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SASongsTableViewCell class])];
}

- (void)loadCachedSongs {
    if (self.album.songs.count > 0) {
        self.songs = [self.album songsSortedByTrackNumber];
    }
}

- (void)downloadLatestSongs {
    [SAAFNetworkingManager getAlbumSongs:self.album.spotifyID withCompletionHandler:^(NSArray *songs, NSError *error) {
        if (!error) {
            self.songs = songs;
            [self.tableView reloadData];
        } else {
            NSLog(@"Error loading songs");
        }
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SASongsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SASongsTableViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithSong:self.songs[indexPath.row]];
    return cell;
}

@end
