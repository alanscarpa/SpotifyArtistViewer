//
//  SASavedDataHandler.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASavedDataHandler.h"
#import "SDWebImageDownloader.h"
#import "Album.h"
#import "SAAFNetworkingManager.h"
#import "Song.h"

NSString * const kPhotosDirectory = @"Photos";

@implementation SASavedDataHandler

+ (void)addArtist:(Artist *)artist toFavorites:(SADataStore *)dataStore {
    [self saveArtistPhoto:artist];
    [self saveArtist:artist toCoreData:dataStore];
}

+ (void)saveArtistPhoto:(Artist *)artist {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:artist.imageLocalURL] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            [self saveImage:image path:artist.spotifyID];
        }
    }];
}

+ (void)saveArtist:(Artist *)artist toCoreData:(SADataStore *)dataStore {
    artist.isFavorite = @(YES);
    NSMutableArray *artistAlbums = [[NSMutableArray alloc] init];
    [SAAFNetworkingManager getArtistAlbums:artist.spotifyID withCompletionHandler:^(NSArray *albums, NSError *error) {
        for (Album *artistAlbum in albums){
            [artistAlbums addObject:artistAlbum];
        }
        artist.album = [NSSet setWithArray:artistAlbums];
        [dataStore save];
    }];
}

+ (void)saveSongs:(NSArray *)songs fromAlbum:(Album *)album toCoreData:(SADataStore *)dataStore {
    for (Song *song in songs) {
        Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:dataStore.managedObjectContext];
        newSong.name = song.name;
        newSong.trackNumber = song.trackNumber;
        [album addSongObject:newSong];
    }
    [dataStore save];
}

#pragma mark - Helper Methods

+ (UIImage *)localImageWithArtist:(Artist *)artist {
    if (artist.imageLocalURL) {
        return [UIImage imageWithContentsOfFile:[[self photosDirectory] stringByAppendingPathComponent:artist.spotifyID]];
    }
    return nil;
}

+ (void)saveImage:(UIImage *)image path:(NSString *)path {
    [self createPhotosDirectoryIfNecessary];
    [UIImagePNGRepresentation(image) writeToFile:[[self photosDirectory] stringByAppendingPathComponent:path]
                                      atomically:YES];
}

+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)photosDirectory {
    return [[self documentsDirectory] stringByAppendingPathComponent:kPhotosDirectory];
}

+ (void)createPhotosDirectoryIfNecessary {
    NSError *error = nil;
    NSString *photosDirectory = [self photosDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:photosDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:photosDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

@end
