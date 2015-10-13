//
//  SAArtistViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAArtistDetailsViewController.h"
#import "SAAFNetworkingManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SAAlbumsViewController.h"
#import "SAConstants.h"
#import "SALocalFileManager.h"
#import "SADataStore.h"

@interface SAArtistDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation SAArtistDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self loadCachedBio];
    [self getArtistBioFromEchoNest];
}

- (void)setUpUI {
    [self.activityIndicator startAnimating];
    [self checkIfArtistIsFavorite];
    [self setArtistName];
    [self setArtistImage];
}

- (void)checkIfArtistIsFavorite {
    if ([self.artist.isFavorite isEqual:@(YES)]) {
        [self.favoriteButton setTitle:@"❌ - Remove From Favorites" forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setTitle:@"♥ - Add to Favorites" forState:UIControlStateNormal];
    }
}

- (void)setArtistName {
    self.artistNameLabel.text = self.artist.name;
}

- (void)setArtistImage {
    [self loadCachedProfileImage];
    [self loadLatestProfileImage];
}

- (void)loadCachedProfileImage {
    UIImage *cachedImage = [SALocalFileManager fetchImageNamed:self.artist.spotifyID];
    if (cachedImage) {
        self.profileImageView.image = cachedImage;
    }
}

- (void)loadLatestProfileImage {
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.artist.imageURLString]
                             placeholderImage:nil
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        [self.activityIndicator stopAnimating];
                                        if (error) {
                                            self.profileImageView.image = [UIImage imageNamed:kNoImagePhotoName];
                                        }
                                    }];
}

- (void)loadCachedBio {
    if (self.artist.biography) {
        [self updateBiographyTextViewWithBio:self.artist.biography];
    }
}

- (void)getArtistBioFromEchoNest {
    [SAAFNetworkingManager getArtistBiography:self.artist.spotifyID withCompletionHandler:^(NSString *artistBio, NSError *error) {
        if (!error) {
            [self updateBiographyTextViewWithBio:artistBio];
        } else {
            NSLog(@"Error calling echonest: %@", error);
        }
    }];
}

- (void)updateBiographyTextViewWithBio:(NSString *)bio {
    self.biographyTextView.text = bio;
    [self.biographyTextView flashScrollIndicators];
    [self.biographyTextView setContentOffset:CGPointZero animated:NO];
}

- (IBAction)favoriteButtonTapped:(id)sender {
    if ([self.artist.isFavorite isEqual:@(YES)]) {
        [[SADataStore sharedDataStore] unflagArtistAsFavorite:self.artist];
    } else {
        [[SADataStore sharedDataStore] flagArtistAsFavorite:self.artist];
    }
    [self checkIfArtistIsFavorite];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SAAlbumsViewController *destinationVC = [segue destinationViewController];
    destinationVC.artist = self.artist;
}

@end
