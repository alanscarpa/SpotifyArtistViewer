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
#import <SDWebImage/UIImageView+WebCache.h>

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
    [SAAFNetworkingManager sendGETRequestWithQuery:self.searchBar.text withCompletionHandler:^(NSArray *artists, NSError *error) {
        if (artists){
            [self updateTableViewWithSearchResults:artists];
        } else {
            NSLog(@"Error calling Spotify API: %@", error);
        }
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
     return [self customizeCell:[tableView dequeueReusableCellWithIdentifier:@"SASearchTableViewCell" forIndexPath:indexPath] atIndexPath:indexPath];
}

- (UITableViewCell*)customizeCell:(SASearchTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath {
    SAArtist *artist = self.artistsFromSearch[indexPath.row];
    cell.artistName.text = artist.artistName;
    cell.artistGenres.text = [artist.genres componentsJoinedByString:@", "];
    cell.artistPopularity.text = artist.popularity;
    [cell.artistImage sd_setImageWithURL:artist.artistSearchThumbnailImageURL
                         placeholderImage:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //[self.activityIndicator stopAnimating];
                                    if (error){
                                        cell.artistImage.image = [UIImage imageNamed:@"noImage.jpg"];
                                    }
                                }];
    return cell;
}

#pragma mark - Helper Methods


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SAArtistViewController *destinationVC = [segue destinationViewController];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    destinationVC.artist = self.artistsFromSearch[selectedRowIndexPath.row];
}

@end
