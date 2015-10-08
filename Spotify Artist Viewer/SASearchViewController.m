//
//  SASearchViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAArtistDetailsViewController.h"
#import "SAAFNetworkingManager.h"
#import "SASearchTableViewCell.h"
#import "SASearchTableViewCell+Customization.h"
#import "SASearchCollectionViewCell+Customization.h"
#import "SAInfiniteScrollHandler.h"
#import "SASearchCollectionViewCell.h"
#import "SADataStore.h"
#import "Artist.h"
#import "Album.h"
#import "Song.h"
#import "SDImageCache.h"

static NSInteger const kReturnLimit = 10;

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SAInfiniteScrollHandlerDelegate, SASearchTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *artistsFromSearch;
@property (strong, nonatomic) SAInfiniteScrollHandler *infiniteScrollHandler;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableArray *tableViewConstraints;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SADataStore *dataStore;

@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCoreData];
    [self prepareArtistsArray];
    [self setSearchBarDelegate];
    [self setUpInfiniteScroll];
}

- (void)prepareCoreData {
    self.dataStore = [SADataStore sharedDataStore];
}

- (void)prepareArtistsArray {
    self.artistsFromSearch = [[NSMutableArray alloc] init];
}

- (void)setSearchBarDelegate {
    self.searchBar.delegate = self;
}

- (void)setUpInfiniteScroll {
    self.infiniteScrollHandler = [[SAInfiniteScrollHandler alloc] init];
    self.infiniteScrollHandler.delegate = self;
    [self.infiniteScrollHandler addInfiniteScrollOnScrollView:self.tableView];
    [self.infiniteScrollHandler addInfiniteScrollOnScrollView:self.collectionView];
}

#pragma mark - Segmented Control

- (IBAction)segmedControlTapped:(id)sender {
    [self checkWhichSegmentWasTapped];
}

- (void)checkWhichSegmentWasTapped {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self showTableView];
    } else {
        [self showCollectionView];
    };
}

- (void)showTableView {
    [UIView transitionFromView:self.collectionView
                        toView:self.tableView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                    completion:nil];
}

- (void)showCollectionView {
    [UIView transitionFromView:self.tableView
                        toView:self.collectionView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                    completion:nil];
}

#pragma mark - Search function

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self clearPreviousArtistSearchResults];
    [self resetInfiniteScrollOffset];
    [self requestAdditionalIemsWithScrollHandler:self.infiniteScrollHandler];
    [self.searchBar resignFirstResponder];
}

- (void)clearPreviousArtistSearchResults {
    [self.artistsFromSearch removeAllObjects];
}

- (void)resetInfiniteScrollOffset {
    self.infiniteScrollHandler.offset = 0;
}

#pragma mark - SAInfiniteScrollHandlerDelegate

- (void)requestAdditionalIemsWithScrollHandler:(SAInfiniteScrollHandler *)scrollHandler {
    [SAAFNetworkingManager searchForArtistsWithQuery:self.searchBar.text withReturnLimit:kReturnLimit withOffset:self.artistsFromSearch.count withCompletionHandler:^(NSArray *artists, NSError *error) {
        if (artists) {
            [self updateDataWithSearchResults:artists];
        } else {
            NSLog(@"Error calling Spotify API: %@", error);
        }
    }];
}

- (void)updateDataWithSearchResults:(NSArray *)results {
    [self.artistsFromSearch addObjectsFromArray:results];
    [self updateResults];
}

- (void)updateResults {
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artistsFromSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SASearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SASearchTableViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithArtist:self.artistsFromSearch[indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.artistsFromSearch.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SASearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SASearchCollectionViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithArtist:self.artistsFromSearch[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:@"favoritesSegue"]) {
        SAArtistDetailsViewController *destinationVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self indexPathFromSegue:segue andSender:sender];
        destinationVC.artist = self.artistsFromSearch[indexPath.row];
    }
}

- (NSIndexPath *)indexPathFromSegue:(UIStoryboardSegue *)segue andSender:(id)sender {
    if ([segue.identifier isEqualToString:@"artistProfileSegueFromCollectionView"]) {
        return [self.collectionView indexPathForCell:sender];
    } else {
        return [self.tableView indexPathForSelectedRow];
    }
}

#pragma mark - SASearchTableViewCell Delegate Methods

- (void)didTapFavoritesWithSearchTableViewCell:(SASearchTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath && indexPath.row < self.artistsFromSearch.count) {
        [self.dataStore saveArtistToFavorites:self.artistsFromSearch[indexPath.row]];
    }
}

@end
