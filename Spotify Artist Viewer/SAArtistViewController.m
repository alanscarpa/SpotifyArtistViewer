//
//  SAArtistViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SARequestManager.h"
#import <SDWebImage/UIIMageView+WebCache.h>

@interface SAArtistViewController ()

@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SAArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.artistNameLabel.text = self.artist.artistName;
    [self getArtistInfoFromEchoNest];
}

-(void)getArtistInfoFromEchoNest {
    SARequestManager *requestManager = [SARequestManager sharedManager];
    [requestManager getArtistInfoWithSpotifyID:self.artist.artistSpotifyID success:^(NSDictionary *results) {
        NSString *artistBio = [[NSString alloc]init];
        NSString *artistImageURL = [[NSString alloc]init];
        for (NSDictionary *bio in results[@"response"][@"artist"][@"biographies"]) {
            // Find the first biography that is not truncated
            if ((NSUInteger)bio[@"truncated"] == 0) {
                artistBio = [NSString stringWithFormat:@"%@", bio[@"text"]];
                break;
            }
        }
        if ([results[@"response"][@"artist"][@"images"] count] > 0) {
            artistImageURL = [NSString stringWithFormat:@"%@", results[@"response"][@"artist"][@"images"][0][@"url"]];
        }
        [self updateArtistWithBio:artistBio andPictureURL:artistImageURL];
    } failure:^(NSError *error) {
        NSLog(@"Error getting data from EchoNest: %@", error);
    }];
}

- (void)updateArtistWithBio:(NSString*)bio andPictureURL:(NSString*)url {
    if ([bio isEqualToString:@""])
    {
       self.artist.artistBiography = @"No biography available.";
    } else {
       self.artist.artistBiography = bio;
    }
    [self updateBioTextViewSize];
    if (![url isEqualToString:@""]){
        [self.profileImage sd_setImageWithURL:[NSURL URLWithString:url]
                             placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 if (!error){
                                     [self.activityIndicator stopAnimating];
                                     self.artist.artistImage = image;
                                 } else {
                                     // SOMETIMES IMAGE URL RETURNED DOES NOT WORK, SO WE DISPLAY NOIMAGE PHOTO IN THESE CASES
                                     [self.activityIndicator stopAnimating];
                                     self.profileImage.image = [UIImage imageNamed:@"noImage.jpg"];
                                 }
                            }];
    } else {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.activityIndicator stopAnimating];
            self.profileImage.image = [UIImage imageNamed:@"noImage.jpg"];
        }];
    }
}

- (void)updateArtistImage {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.activityIndicator stopAnimating];
        self.profileImage.image = self.artist.artistImage;
    }];
}

-(void)updateBioTextViewSize {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.biographyTextView.text = self.artist.artistBiography;
        self.biographyTextView.scrollEnabled = NO;
        CGSize sizeThatFitsTextView = [self.biographyTextView sizeThatFits:self.biographyTextView.frame.size];
        self.textViewHeightConstraint.constant = sizeThatFitsTextView.height;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
