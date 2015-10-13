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

@interface SAArtistDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SAArtistDetailsViewController

#warning add ability to favorite/unfavorite from here

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self loadCachedBio];
    [self getArtistBioFromEchoNest];
}

- (void)setUpUI {
    [self.activityIndicator startAnimating];
    [self setArtistName];
    [self setArtistImage];
}

- (void)loadCachedBio {
    if (self.artist.biography) {
        [self updateBiographyTextViewWithBio:self.artist.biography];
    }
}

- (void)updateBiographyTextViewWithBio:(NSString *)bio {
    self.biographyTextView.text = bio;
    [self.biographyTextView flashScrollIndicators];
    [self.biographyTextView setContentOffset:CGPointZero animated:NO];
}

- (void)setArtistName {
    self.artistNameLabel.text = self.artist.name;
}

- (void)setArtistImage {
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.artist.imageLocalURL]
                         placeholderImage:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [self.activityIndicator stopAnimating];
                                    if (error) {
                                        self.profileImageView.image = [UIImage imageNamed:kNoImagePhotoName];
                                    }
                                }];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SAAlbumsViewController *destinationVC = [segue destinationViewController];
    destinationVC.artist = self.artist;
}

@end
