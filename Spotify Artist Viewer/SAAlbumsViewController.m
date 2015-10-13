//
//  SAFavoritesDetailViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAAlbumsViewController.h"
#import "Album.h"
#import "SAAlbumsCollectionViewCell.h"
#import "SAAlbumsCollectionViewCell+Customization.h"
#import "SASongsViewController.h"
#import "SAAFNetworkingManager.h"

@interface SAAlbumsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *albums;

@end

@implementation SAAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAlbums];
}

- (void)loadAlbums {
    [SAAFNetworkingManager getArtistAlbums:self.artist.spotifyID withCompletionHandler:^(NSArray *albums, NSError *error) {
        if (!error) {
            self.albums = albums;
            [self.collectionView reloadData];
        } else {
            NSLog(@"Error getting albums: %@", error);
        }
    }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAAlbumsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAAlbumsCollectionViewCell class])
                                                                                 forIndexPath:indexPath];
    [cell customizeCellWithAlbum:self.albums[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4);
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    SASongsViewController *destinationVC = [segue destinationViewController];
    destinationVC.album = self.albums[indexPath.row];
}

@end
