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

@end

@implementation SAArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateArtistInfoWithEchoNest];
}


-(void)updateArtistInfoWithEchoNest
{
    
    SARequestManager *requestManager = [SARequestManager sharedManager];
    [requestManager getArtistInfoWithSpotifyID:self.artist.artistSpotifyID success:^(NSDictionary *results) {
        
        NSString *artistBio = [[NSString alloc]init];
    
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
            NSString *artistImageURL = [NSString stringWithFormat:@"%@", results[@"response"][@"artist"][@"images"][0][@"url"]];
            NSLog(@"%@\n%@", artistImageURL, artistBio);
        } else {
            NSLog(@"No image available");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Error getting data from EchoNest: %@", error);
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
