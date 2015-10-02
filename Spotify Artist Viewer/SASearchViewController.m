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
#import "SASavedDataHandler.h"
#import "SADataStore.h"
#import "Artist.h"
#import "Album.h"
#import "Song.h"

static NSInteger const kReturnLimit = 3;

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SAInfiniteScrollHandlerDelegate>
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

# pragma mark - Save Artist To Favorites

- (IBAction)favoriteButtonTapped:(UIButton *)favoriteButton {
    [SASavedDataHandler addArtist:self.artistsFromSearch[favoriteButton.tag] andImage:[self artistImageFromFavoriteButton:favoriteButton] toFavorites:self.dataStore];
}

- (UIImage *)artistImageFromFavoriteButton:(UIButton *)favoriteButton {
    CGPoint location = [favoriteButton.superview convertPoint:favoriteButton.center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    SASearchTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.artistImage.image;
}

- (void)createDummyCoreData {
    Artist *newArtist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.dataStore.managedObjectContext];
    newArtist.name = @"some band";
    
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:self.dataStore.managedObjectContext];
    album.name = @"album111";
    
    Song *song1 = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.dataStore.managedObjectContext];
    song1.name = @"song1";
    Song *song2 = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.dataStore.managedObjectContext];
    song2.name = @"song2";
    [album addSong:[[NSSet alloc] initWithArray:@[song1, song2]]];
    [newArtist addAlbumObject:album];
    
    [self.dataStore save];
    NSFetchRequest *requestArtists = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    NSSortDescriptor *sortArtistsByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    requestArtists.sortDescriptors = @[sortArtistsByName];
    
    NSArray *savedArtists = [self.dataStore.managedObjectContext executeFetchRequest:requestArtists error:nil];
    for (Artist *artist in savedArtists) {
        NSLog(@"Name: %@", artist.name);
        for (Album *albumm in artist.album){
            NSLog(@"Albums: %@", albumm.name);
            for (Song *songg in albumm.song){
                NSLog(@"Songs: %@", songg.name);
            }
        }
    };
    //NSLog(@"%@", [self.dataStore.managedObjectContext executeFetchRequest:requestArtists error:nil]);

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
    [self scrollHandler:nil requestAdditionalItemsFromOffset:0];
    [self.searchBar resignFirstResponder];
}

- (void)clearPreviousArtistSearchResults {
    [self.artistsFromSearch removeAllObjects];
}

- (void)resetInfiniteScrollOffset {
    self.infiniteScrollHandler.offset = 0;
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

- (void)updateTableViewWithSearchResults:(NSArray *)results {
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
    [cell customizeCellWithArtist:self.artistsFromSearch[indexPath.row] atIndexPath:indexPath];
    cell.tag = indexPath.row;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/2,self.view.frame.size.height/4.5);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"artistProfileSegue"]) {
        SAArtistViewController *destinationVC = [segue destinationViewController];
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        destinationVC.artist = self.artistsFromSearch[selectedRowIndexPath.row];
    } else if ([segue.identifier isEqualToString:@"artistProfileSegue"]) {
        
    }
}

@end
