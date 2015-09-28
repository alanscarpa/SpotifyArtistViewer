//
//  SAArtistViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SARequestManager.h"

@interface SAArtistViewController ()

@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;


@end

@implementation SAArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getArtistInfoFromEchoNest];
}




-(void)getArtistInfoFromEchoNest
{
    
    SARequestManager *requestManager = [SARequestManager sharedManager];
    [requestManager getArtistInfoWithSpotifyID:self.artist.artistSpotifyID success:^(NSDictionary *results) {
        
        NSString *artistBio = [[NSString alloc]init];
        NSString *artistImageURL = [[NSString alloc]init];
        
        for (NSDictionary *bio in results[@"response"][@"artist"][@"biographies"])
        {
            // Find the first biography that is not truncated
            if ((NSUInteger)bio[@"truncated"] == 0){
                artistBio = [NSString stringWithFormat:@"%@", bio[@"text"]];
                break;
            }
        }
        
        if ([artistBio isEqualToString:@""]){
            NSLog(@"No bio available");
        }
        
        if ([results[@"response"][@"artist"][@"images"] count] > 0){
            artistImageURL = [NSString stringWithFormat:@"%@", results[@"response"][@"artist"][@"images"][0][@"url"]];
            NSLog(@"%@\n%@", artistImageURL, artistBio);
        } else {
            NSLog(@"No image available");
        }
        
        self.artist.artistBiography = artistBio;
        NSURL *imageURL = [NSURL URLWithString:artistImageURL];
        NSOperationQueue *operationQ = [[NSOperationQueue alloc]init];
        [operationQ addOperationWithBlock:^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            self.artist.artistImage = [UIImage imageWithData:imageData];
            [self updateUI];
        }];
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"Error getting data from EchoNest: %@", error);
    }];
    
}


-(void)updateUI
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.profileImage.image = self.artist.artistImage;
        self.biographyTextView.text = self.artist.artistBiography;
        [self updateBioTextViewSize];
    }];
}

-(void)updateBioTextViewSize
{
    
 
    self.biographyTextView.scrollEnabled = NO;
    CGSize sizeThatFitsTextView = [self.biographyTextView sizeThatFits:self.biographyTextView.frame.size];
    self.textViewHeightConstraint.constant = sizeThatFitsTextView.height;
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
