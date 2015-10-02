//
//  SAFavoritesViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesViewController.h"
#import "SAFavoritesTableViewCell.h"

@interface SAFavoritesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SAFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerTableViewCellNib];
}

- (void)registerTableViewCellNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"SAFavoritesViewControllerCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([SAFavoritesTableViewCell class])];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SAFavoritesTableViewCell class]) forIndexPath:indexPath];
    return cell;
}

@end
