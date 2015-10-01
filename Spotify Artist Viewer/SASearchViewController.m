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
#import "SASearchCollectionViewCell+SASearchCollectionViewCellCustomizer.h"
#import "SAInfiniteScrollHandler.h"
#import <PureLayout/PureLayout.h>
#import "SASearchCollectionViewCell.h"

static NSInteger const kReturnLimit = 3;

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SAInfiniteScrollHandlerDelegate>
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
    self.artistsFromSearch = [[NSMutableArray alloc] init];
}

- (void)setSearchBarDelegate {
    self.searchBar.delegate = self;
}

- (void)setUpInfiniteScroll {
    self.infiniteScrollHandler = [[SAInfiniteScrollHandler alloc] init];
    self.infiniteScrollHandler.delegate = self;
    [self.infiniteScrollHandler setUpInfiniteScrollOnScrollView:self.tableView withSearchLimit:kReturnLimit];
}

- (void)saveTableViewStoryboardConstraints {
    self.tableViewConstraints = [[NSMutableArray alloc] init];
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
    [self.collectionView registerClass:[SASearchCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SASearchCollectionViewCell class])];
    self.collectionView.backgroundColor = [UIColor orangeColor];
    self.collectionView.alwaysBounceVertical = YES;
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
    [self.collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:0.0];
    [self.collectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:0.0];
    [self.collectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:0.0];
    [self.collectionView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:0.0];
    [super updateViewConstraints];
}

#pragma mark - Search function

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self clearPreviousArtistSearchResults];
    [self resetInfiniteScrollOffset];
    [self scrollHandler:nil requestAdditionalItemsFromOffset:0];
    [self.searchBar resignFirstResponder];
}

- (void)clearPreviousArtistSearchResults {
    [self.artistsFromSearch removeAllObjects];
}

- (void)resetInfiniteScrollOffset {
    self.infiniteScrollHandler.offset = 0;
}

- (void)updateTableViewWithSearchResults:(NSArray *)results {
    [self.artistsFromSearch addObjectsFromArray:results];
    [self updateTableView];
}

- (void)updateTableView {
    [self.tableView reloadData];
}

#pragma mark - SAInfiniteScrollHandlerDelegate

- (void)scrollHandler:(SAInfiniteScrollHandler *)scrollHandler requestAdditionalItemsFromOffset:(NSInteger)offset {
    [SAAFNetworkingManager sendGETRequestWithQuery:self.searchBar.text withReturnLimit:kReturnLimit withOffset:offset withCompletionHandler:^(NSArray *artists, NSError *error) {
        if (artists){
            [self updateTableViewWithSearchResults:artists];
        } else {
            NSLog(@"Error calling Spotify API: %@", error);
        }
    }];
}

#pragma mark - UITableViewDataSource

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
    return self.artistsFromSearch.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SASearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SASearchCollectionViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithArtist:self.artistsFromSearch[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/2,self.view.frame.size.height/4.5);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 16, 0, 16);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SAArtistViewController *destinationVC = [segue destinationViewController];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    destinationVC.artist = self.artistsFromSearch[selectedRowIndexPath.row];
}

@end
