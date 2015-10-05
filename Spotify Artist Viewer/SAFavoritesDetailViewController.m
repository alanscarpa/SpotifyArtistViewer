//
//  SAFavoritesDetailViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/5/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesDetailViewController.h"
#import "Album.h"
#import "SAFavoritesDetailCollectionViewCell.h"

@interface SAFavoritesDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *sortedAlbums;
@end

@implementation SAFavoritesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sortAlbums];

    for (Album *album in self.artist.album){
        NSLog(@"%@", album.name);
        NSLog(@"URL: %@", album.imageLocalURL);
        NSLog(@"%@", album.spotifyID);
    }
    
}

- (void)sortAlbums {
    self.sortedAlbums = [[self.artist.album allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sortedAlbums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAFavoritesDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAFavoritesDetailCollectionViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithAlbum:self.sortedAlbums[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/2,self.view.frame.size.height/4.5);
}


@end
