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
#import "SAInfiniteScrollHandler.h"

static NSInteger const kReturnLimit = 3;

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *artistsFromSearch;
@property (strong, nonatomic) SAInfiniteScrollHandler *infiniteScrollHandler;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *tableViewConstraints;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareArtistsArray];
    [self setSearchBarDelegate];
    [self setUpInfiniteScroll];
    self.tableViewConstraints = [[NSMutableArray alloc]init];
}

- (void)prepareArtistsArray {
    self.artistsFromSearch = [[NSMutableArray alloc]init];
}

- (void)setSearchBarDelegate {
    self.searchBar.delegate = self;
}

- (void)setUpInfiniteScroll {
    self.infiniteScrollHandler = [[SAInfiniteScrollHandler alloc]init];
    [self.infiniteScrollHandler setUpInfiniteScrollOnViewController:self withSearchLimit:kReturnLimit];
}

- (IBAction)segmedControlTapped:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0){
        NSLog(@"List");
        [self.view addSubview:self.tableView];
        for (NSLayoutConstraint *constraint in self.tableViewConstraints){
            [self.view addConstraint:constraint];
        }
    } else {
        NSLog(@"Collection");
        for (NSLayoutConstraint *constraint in self.view.constraints){
            if (constraint.firstItem == self.tableView || constraint.secondItem == self.tableView){
              [self.tableViewConstraints addObject:constraint];
            }
        }
        
        [self.tableView removeFromSuperview];
    };
}

#pragma mark - Search function

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self clearPreviousArtistSearchResults];
    [self resetInfiniteScrollOffset];
    [self searchForSpotifyArtistWithOffset:0];
    [self.searchBar resignFirstResponder];
}

- (void)clearPreviousArtistSearchResults {
    [self.artistsFromSearch removeAllObjects];
}

- (void)resetInfiniteScrollOffset {
    self.infiniteScrollHandler.offset = 0;
}

- (void)searchForSpotifyArtistWithOffset:(NSInteger)offset {
    [SAAFNetworkingManager sendGETRequestWithQuery:self.searchBar.text withReturnLimit:kReturnLimit withOffset:offset withCompletionHandler:^(NSArray *artists, NSError *error) {
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
