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

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *artistsFromSearch;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchBarDelegate];
}

-(void)setSearchBarDelegate {
    self.searchBar.delegate = self;
}

#pragma mark - Search function

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchForSpotifyArtist];
    [self.searchBar resignFirstResponder];
}

-(void)searchForSpotifyArtist {
    [[SARequestManager sharedManager] getArtistsWithQuery:self.searchBar.text success:^(NSDictionary *artists) {
        [self updateTableViewWithSearchResults:artists];
    } failure:^(NSError *error) {
        NSLog(@"API Call to Spotify failed with error: %@", error);
    }];
}

- (void)updateTableViewWithSearchResults:(NSDictionary*)results {
    [self populateArtistsArrayWithSearchResults:results];
    [self updateTableView];
}

- (void)populateArtistsArrayWithSearchResults:(NSDictionary*)results {
    self.artistsFromSearch = [[NSMutableArray alloc]init];
    for (NSDictionary *artist in results[@"artists"][@"items"]) {
        NSString *artistName = [NSString stringWithFormat:@"%@", artist[@"name"]];
        NSString *spotifyID = [NSString stringWithFormat:@"%@", artist[@"id"]];
        SAArtist *artist = [[SAArtist alloc]initWithName:artistName biography:@"Amazing songwriter.  Best of the generation!" image:nil spotifyID:spotifyID];
        [self.artistsFromSearch addObject:artist];
    }
}

- (void)updateTableView {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artistsFromSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     return [self customizeCell:[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath] atIndexPath:indexPath];
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
