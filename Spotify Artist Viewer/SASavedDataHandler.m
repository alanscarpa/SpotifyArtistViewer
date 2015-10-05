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
#import "SAAlbum.h"
#import "Song.h"
#import "SASong.h"

NSString * const kPhotosDirectory = @"Photos";

@implementation SASavedDataHandler

+ (void)addArtist:(SAArtist *)artist toFavorites:(SADataStore *)dataStore {
    [self saveArtistPhoto:artist];
    [self saveArtist:artist toCoreData:dataStore];
}

+ (void)saveArtistPhoto:(SAArtist *)artist {
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:artist.artistSearchThumbnailImageURL options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image) {
            [self saveImage:image path:artist.artistSpotifyID];
        }
    }];
}

+ (void)saveArtist:(SAArtist *)artist toCoreData:(SADataStore *)dataStore {
    Artist *artistToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:dataStore.managedObjectContext];
    artistToSave.name = artist.artistName;
    artistToSave.imageLocalURL = artist.artistSpotifyID;
    NSMutableArray *artistAlbums = [[NSMutableArray alloc] init];
    [SAAFNetworkingManager getArtistAlbums:artist.artistSpotifyID withCompletionHandler:^(NSArray *albums, NSError *error) {
        for (SAAlbum *artistAlbum in albums){
            Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:dataStore.managedObjectContext];
            album.name = artistAlbum.title;
            album.imageLocalURL = artistAlbum.albumImageURL;
            album.spotifyID = artistAlbum.spotifyID;
            [artistAlbums addObject:album];
        }
        artistToSave.album = [NSSet setWithArray:artistAlbums];
        [dataStore save];
    }];
}

+ (void)saveSongs:(NSArray *)songs fromAlbum:(Album *)album toCoreData:(SADataStore *)dataStore {
    for (SASong *song in songs) {
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
        return [UIImage imageWithContentsOfFile:[[self photosDirectory] stringByAppendingPathComponent:artist.imageLocalURL]];
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
