//
//  SASongsViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASongsViewController.h"
#import "SAAFNetworkingManager.h"
#import "SASong.h"
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
    [self checkIfSongsHaveBeenPreviouslyDownloaded];
    
}

- (void)registerTableViewCell {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SASongsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SASongsTableViewCell class])];
}
- (void)checkIfSongsHaveBeenPreviouslyDownloaded {
    if (![self songsHaveBeenPreviouslyDownloadedToCoreData]) {
        [SAAFNetworkingManager getAlbumSongs:self.album.spotifyID withCompletionHandler:^(NSArray *songs, NSError *error) {
            [SASavedDataHandler saveSongs:songs fromAlbum:self.album toCoreData:[SADataStore sharedDataStore]];
        }];
    } else {
        [self getSongsFromCoreData];
    }
}

- (BOOL)songsHaveBeenPreviouslyDownloadedToCoreData{
    if (self.album.song.count > 0){
        return YES;
    } else {
        return NO;
    }
}

- (void)getSongsFromCoreData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    //   NSSortDescriptor *sortArtistsByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    //   request.sortDescriptors = @[sortArtistsByName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"album == %@", self.album];
    request.predicate = predicate;
    
    self.songs = [[SADataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
    for (Song *song in self.songs){
        NSLog(@"%@", song.name);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SASongsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SASongsTableViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithCoreDataAlbum:self.songs[indexPath.row]];
    return cell;
}

@end
