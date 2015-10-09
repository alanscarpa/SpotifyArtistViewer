//
//  SAFavoritesViewController.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesViewController.h"
#import "SAFavoritesTableViewCell.h"
#import "SADataStore.h"
#import "SAAFNetworkingManager.h"
#import "Artist.h"
#import "SAArtistDetailsViewController.h"
#import "SAFavoritesTableViewCell+Customization.h"
#import "NSFetchedResultsController+SAHelpers.h"

@interface SAFavoritesViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SADataStore *dataStore;
@property (strong, nonatomic) NSArray *favoriteArtists;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SAFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCoreData];
    [self retrieveFavoriteArtistsFromCoreData];
    [self registerTableViewCellNib];
    [self createDeleteButton];
}

# pragma mark - ViewController Setup

- (void)initializeCoreData {
    self.dataStore = [SADataStore sharedDataStore];
}

- (void)retrieveFavoriteArtistsFromCoreData {
    [self setUpFetchedResultsController];
    [self fetchArtistsFromFetchedResultsController];
}

- (void)setUpFetchedResultsController {
    self.fetchedResultsController = [NSFetchedResultsController sa_createFavoriteArtistsFetchedResultsControllerWithManagedObjectContext:self.dataStore.managedObjectContext];
    self.fetchedResultsController.delegate = self;
}

- (void)fetchArtistsFromFetchedResultsController {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
        self.favoriteArtists = self.fetchedResultsController.fetchedObjects;
    }
}

- (void)registerTableViewCellNib {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SAFavoritesTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SAFavoritesTableViewCell class])];
}

- (void)createDeleteButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditMode)];
}

- (void)toggleEditMode {
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    SAArtistDetailsViewController *destinationVC = [segue destinationViewController];
    destinationVC.artist = self.favoriteArtists[indexPath.row];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.favoriteArtists = controller.fetchedObjects;
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteArtists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SAFavoritesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SAFavoritesTableViewCell class]) forIndexPath:indexPath];
    [cell customizeCellWithArtist:self.favoriteArtists[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"artistDetailsSegue" sender:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            [self.dataStore unflagArtistAsFavorite:self.favoriteArtists[indexPath.row]];
        }
            break;
        default:
            break;
    }
}

@end
