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
#import "SAAFNetworkingManager.h"
#import "SASearchTableViewCell.h"
#import "SASearchTableViewCell+SASearchCellCustomizer.h"
#import <UIScrollView+InfiniteScroll.h>

static NSString * const kCellName = @"cell";

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *artistsFromSearch;
@property (nonatomic) NSUInteger searchOffset;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.artistsFromSearch = [[NSMutableArray alloc]init];
    self.searchOffset = 0;
    [self setSearchBarDelegate];
    [self setUpInfiniteScroll];
}

- (void)setSearchBarDelegate {
    self.searchBar.delegate = self;
}

- (void)setUpInfiniteScroll {
    // change indicator view style to white
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        self.searchOffset += 3;
        [self searchForSpotifyArtist];
        [tableView finishInfiniteScroll];
    }];
}

#pragma mark - Search function

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self clearPreviousArtistSearchResults];
    [self searchForSpotifyArtist];
    [self.searchBar resignFirstResponder];
}

- (void)clearPreviousArtistSearchResults {
    [self.artistsFromSearch removeAllObjects];
}

- (void)searchForSpotifyArtist {
    [SAAFNetworkingManager sendGETRequestWithQuery:self.searchBar.text withOffset:self.searchOffset withCompletionHandler:^(NSArray *artists, NSError *error) {
        if (artists){
            [self updateTableViewWithSearchResults:artists];
        } else {
            NSLog(@"Error calling Spotify API: %@", error);
        }
    }];
}

- (void)updateTableViewWithSearchResults:(NSArray *)results {
    [self.artistsFromSearch addObjectsFromArray:results];
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
    SASearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SASearchTableViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithArtist:self.artistsFromSearch[indexPath.row]];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SAArtistViewController *destinationVC = [segue destinationViewController];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    destinationVC.artist = self.artistsFromSearch[selectedRowIndexPath.row];
}

@end
