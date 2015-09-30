//
//  SAArtistViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SARequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SAArtistViewController ()
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation SAArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self getArtistInfoFromEchoNest];
}

- (void)setUpUI {
    [self.activityIndicator startAnimating];
    [self setUpArtistNameLabel];
}

- (void)setUpArtistNameLabel {
    self.artistNameLabel.adjustsFontSizeToFitWidth = YES;
    self.artistNameLabel.minimumScaleFactor = 0.7;
    self.artistNameLabel.text = self.artist.artistName;
}

- (void)getArtistInfoFromEchoNest {
    [[SARequestManager sharedManager] getArtistInfoWithSpotifyID:self.artist.artistSpotifyID success:^(SAArtist *artist) {
        [self updateUIWithArtist:artist];
    } failure:^(NSError *error) {
        NSLog(@"Unable to get artist info from EchoNest");
    }];
}

- (void)updateUIWithArtist:(SAArtist *)artist {
    self.artist = artist;
    [self updateBioTextView];
    [self updateArtistImage];
}

- (void)updateBioTextView {
    self.biographyTextView.text = self.artist.artistBiography;
    self.biographyTextView.hidden = NO;
}

- (void)updateArtistImage {
    [self.profileImage sd_setImageWithURL:self.artist.artistImageURL
                      placeholderImage:nil
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [self.activityIndicator stopAnimating];
                                 if (error){
                                     self.profileImage.image = [UIImage imageNamed:@"noImage.jpg"];
                                 }
                             }];
}

@end
