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
#import "MLPAutoCompleteTextField.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "SAAutoCompleteDataSource.h"

static NSInteger const kReturnLimit = 10;
NSString *const kFavoritesSegueIdentifier = @"favoritesSegue";
NSString *const kArtistDetailsFromCollectionViewSegueIdentifier = @"artistDetailsSegueFromCollectionView";
NSString *const kArtistDetailsFromTableViewSegueIdentifier = @"artistDetailsSegueFromTableView";

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SAInfiniteScrollHandlerDelegate, SASearchTableViewCellDelegate, MLPAutoCompleteTextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) SADataStore *dataStore;
@property (strong, nonatomic) SAInfiniteScrollHandler *infiniteScrollHandler;
@property (strong, nonatomic) SAAutoCompleteDataSource *autocompleteDataSource;

@property (strong, nonatomic) NSMutableArray *tableViewConstraints;
@property (strong, nonatomic) NSMutableArray *artistsFromSearch;

@property (strong, nonatomic) UITapGestureRecognizer *scrollViewTapGestureRecognizer;

@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAutoComplete];
    [self prepareCoreData];
    [self prepareArtistsArray];
    [self setUpInfiniteScroll];
    [self setUpTapGestureRecognizer];
}

- (void)setUpAutoComplete {
    self.autocompleteDataSource = [[SAAutoCompleteDataSource alloc] init];
    self.searchBar.autoCompleteDataSource = self.autocompleteDataSource;
    self.searchBar.delegate = self;
    self.searchBar.autoCompleteDelegate = self;
    self.searchBar.sortAutoCompleteSuggestionsByClosestMatch = YES;
    self.searchBar.reverseAutoCompleteSuggestionsBoldEffect = YES;
}

- (void)prepareCoreData {
    self.dataStore = [SADataStore sharedDataStore];
}

- (void)prepareArtistsArray {
    self.artistsFromSearch = [[NSMutableArray alloc] init];
}

- (void)setUpInfiniteScroll {
    self.infiniteScrollHandler = [[SAInfiniteScrollHandler alloc] init];
    self.infiniteScrollHandler.delegate = self;
    [self.infiniteScrollHandler addInfiniteScrollOnScrollView:self.tableView];
    [self.infiniteScrollHandler addInfiniteScrollOnScrollView:self.collectionView];
}

- (void)setUpTapGestureRecognizer {
    self.scrollViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapReceived:)];
    self.scrollViewTapGestureRecognizer.delegate = self;
    self.scrollViewTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.containerView addGestureRecognizer:self.scrollViewTapGestureRecognizer];
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

- (void)requestAdditionalIemsWithScrollHandler:(SAInfiniteScrollHandler *)scrollHandler {
    [SAAFNetworkingManager searchForArtistsWithQuery:self.searchBar.text
                                     withReturnLimit:kReturnLimit
                                          withOffset:self.artistsFromSearch.count
                               withCompletionHandler:^(NSArray *artists, NSError *error) {
        if (artists) {
            [self updateArtistsWithSearchResults:artists];
        } else {
            NSLog(@"Error calling Spotify API: %@", error);
        }
    }];
}

- (void)updateArtistsWithSearchResults:(NSArray *)results {
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
    SASearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SASearchTableViewCell class])
                                                                  forIndexPath:indexPath];
    [cell customizeCellWithArtist:self.artistsFromSearch[indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.artistsFromSearch.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SASearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SASearchCollectionViewCell class])
                                                                                 forIndexPath:indexPath];
    [cell customizeCellWithArtist:self.artistsFromSearch[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:kFavoritesSegueIdentifier]) {
        SAArtistDetailsViewController *destinationVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self indexPathFromSegue:segue andSender:sender];
        destinationVC.artist = self.artistsFromSearch[indexPath.row];
    }
}

- (NSIndexPath *)indexPathFromSegue:(UIStoryboardSegue *)segue andSender:(id)sender {
    if ([segue.identifier isEqualToString:kArtistDetailsFromCollectionViewSegueIdentifier]) {
        return [self.collectionView indexPathForCell:sender];
    } else {
        return [self.tableView indexPathForSelectedRow];
    }
}

#pragma mark - SASearchTableViewCell Delegate Methods

- (void)didTapFavoritesWithSearchTableViewCell:(SASearchTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath && indexPath.row < self.artistsFromSearch.count) {
        [self.dataStore flagArtistAsFavorite:self.artistsFromSearch[indexPath.row]];
    }
}

#pragma mark - UITextfield Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchForArtists];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITapGestureRecognizer Delegate Methods

- (void)scrollViewTapReceived:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.view endEditing:YES];
}

#pragma mark - Search function

- (void)searchForArtists {
    [self clearPreviousArtistSearchResults];
    [self resetInfiniteScrollOffset];
    [self requestAdditionalIemsWithScrollHandler:self.infiniteScrollHandler];
}

- (void)clearPreviousArtistSearchResults {
    [self.artistsFromSearch removeAllObjects];
}

- (void)resetInfiniteScrollOffset {
    self.infiniteScrollHandler.offset = 0;
}

#pragma mark - MLPAutoCompleteTextField Delegate

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath {
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedObject) {
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
        [self searchForArtists];
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
};

@end
