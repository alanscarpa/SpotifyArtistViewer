//
//  SASearchViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAArtist.h"
#import "SAArtistViewController.h"
#import "SARequestManager.h"

static NSString * const kCellName = @"cell";

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *artistsFromSearch;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchBarDelegate];
}

- (void)setSearchBarDelegate {
    self.searchBar.delegate = self;
}

#pragma mark - Search function

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchForSpotifyArtist];
    [self.searchBar resignFirstResponder];
}

-(void)searchForSpotifyArtist {
    [[SARequestManager sharedManager] getArtistsWithQuery:self.searchBar.text success:^(NSArray *artists) {
        [self updateTableViewWithSearchResults:artists];
    } failure:^(NSError *error) {
        NSLog(@"API Call to Spotify failed with error: %@", error);
    }];
}

- (void)updateTableViewWithSearchResults:(NSArray*)results {
    self.artistsFromSearch = results;
    [self updateTableView];
}

- (void)updateTableView {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artistsFromSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     return [self customizeCell:[tableView dequeueReusableCellWithIdentifier:kCellName forIndexPath:indexPath] atIndexPath:indexPath];
}

- (UITableViewCell*)customizeCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    cell.textLabel.text = [self.artistsFromSearch[indexPath.row] artistName];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SAArtistViewController *destinationVC = [segue destinationViewController];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    destinationVC.artist = self.artistsFromSearch[selectedRowIndexPath.row];
}

@end
