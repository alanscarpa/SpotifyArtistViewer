//
//  SASongsViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASongsViewController.h"
#import "SAAFNetworkingManager.h"
#import "SASavedDataHandler.h"
#import "SADataStore.h"
#import "SASongsTableViewCell.h"

@interface SASongsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *songs;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SASongsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerTableViewCell];
    [self loadSongs];
}

- (void)registerTableViewCell {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SASongsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SASongsTableViewCell class])];
}

- (void)loadSongs {
    [SASavedDataHandler songsFromAlbum:self.album withCompletionBlock:^(NSArray *songs, NSError *error) {
        self.songs = songs;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SASongsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SASongsTableViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithCoreDataSong:self.songs[indexPath.row]];
    return cell;
}

@end
