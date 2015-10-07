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

@interface SAAlbumsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *sortedAlbums;

@end

@implementation SAAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sortAlbums];
}

- (void)sortAlbums {
    self.sortedAlbums = [[self.artist.album allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sortedAlbums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAAlbumsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAAlbumsCollectionViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithAlbum:self.sortedAlbums[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4);
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    SASongsViewController *destinationVC = [segue destinationViewController];
    destinationVC.album = self.sortedAlbums[indexPath.row];
}

@end
