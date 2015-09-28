//
//  SASearchViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASearchViewController.h"
#import "SAArtist.h"
#import "SAArtistViewController.h"
#import "SARequestManager.h"

@interface SASearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
}

-(void)updateTableViewWithSearchResults:(NSDictionary*)results
{
    self.searchResults = [[NSMutableArray alloc]init];

    for (NSDictionary *artist in results[@"artists"][@"items"])
    {
        NSString *artistName = [NSString stringWithFormat:@"%@", artist[@"name"]];
        NSString *spotifyID = [NSString stringWithFormat:@"%@", artist[@"id"]];
        SAArtist *artist = [[SAArtist alloc]initWithName:artistName biography:@"Amazing songwriter.  Best of the generation!" image:nil spotifyID:spotifyID];
        [self.searchResults addObject:artist];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    SARequestManager *requestManager = [SARequestManager sharedManager];
    [requestManager getArtistsWithQuery:self.searchBar.text success:^(NSDictionary *artists) {
        [self updateTableViewWithSearchResults:artists];
    } failure:^(NSError *error) {
        NSLog(@"API Call to Spotify failed with error: %@", error);
    }];
    [self.searchBar resignFirstResponder];

}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     cell.textLabel.text = [self.searchResults[indexPath.row] artistName];
     return cell;
 }


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SAArtistViewController *destinationVC = [segue destinationViewController];
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    destinationVC.artist = self.searchResults[selectedRowIndexPath.row];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */






@end
