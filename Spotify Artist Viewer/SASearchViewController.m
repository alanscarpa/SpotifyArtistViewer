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
#import <PureLayout/PureLayout.h>

static NSInteger const kReturnLimit = 3;

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *artistsFromSearch;
@property (strong, nonatomic) SAInfiniteScrollHandler *infiniteScrollHandler;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *tableViewConstraints;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareArtistsArray];
    [self setSearchBarDelegate];
    [self setUpInfiniteScroll];
    [self saveTableViewStoryboardConstraints];
    [self prepareCollectionView];
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

- (void)saveTableViewStoryboardConstraints {
    self.tableViewConstraints = [[NSMutableArray alloc]init];
    for (NSLayoutConstraint *constraint in self.view.constraints){
        if (constraint.firstItem == self.tableView || constraint.secondItem == self.tableView){
            [self.tableViewConstraints addObject:constraint];
        }
    }
}

- (void)prepareCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    self.collectionView.backgroundColor = [UIColor orangeColor];
}

- (IBAction)segmedControlTapped:(id)sender {
    [self checkWhichSegmentWasTapped];
}

- (void)checkWhichSegmentWasTapped {
    if (self.segmentedControl.selectedSegmentIndex == 0){
        [self showTableView];
    } else {
        [self showCollectionView];
    };
}

- (void)showTableView {
    [self.collectionView removeFromSuperview];
    [self.view addSubview:self.tableView];
    for (NSLayoutConstraint *constraint in self.tableViewConstraints){
        [self.view addConstraint:constraint];
    }
}

- (void)showCollectionView {
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.collectionView];
    [self constrainCollectionView];
}

- (void)constrainCollectionView {
    [self.collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar];
    [self.collectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [self.collectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [self.collectionView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [super updateViewConstraints];
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

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/2.5,self.view.frame.size.height/4.5);
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SAArtistViewController *destinationVC = [segue destinationViewController];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    destinationVC.artist = self.artistsFromSearch[selectedRowIndexPath.row];
}

@end
