//
//  SAArtistViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SAAFNetworkingManager.h"
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
    [self getArtistBioFromEchoNest];
}

- (void)setUpUI {
    [self.activityIndicator startAnimating];
    [self setArtistName];
    [self setArtistImage];
}

- (void)setArtistName {
    self.artistNameLabel.text = self.artist.name;
}

- (void)setArtistImage {
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:self.artist.imageLocalURL]
                         placeholderImage:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [self.activityIndicator stopAnimating];
                                    if (error) {
                                        self.profileImage.image = [UIImage imageNamed:@"noImage.jpg"];
                                    }
                                }];
}

- (void)getArtistBioFromEchoNest {
    [SAAFNetworkingManager getArtistBiography:self.artist.spotifyID withCompletionHandler:^(NSString *artistBio, NSError *error) {
        if (!error) {
            self.biographyTextView.text = artistBio;
            self.biographyTextView.hidden = NO;
        } else {
            NSLog(@"Erro calling echonest: %@", error);
        }
    }];
}

@end
