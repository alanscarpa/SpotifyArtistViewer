//
//  SASavedDataHandler.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "SASavedDataHandler.h"
#import "Artist.h"

@implementation SASavedDataHandler

+ (void)addArtist:(SAArtist *)artist andImage:(UIImage *)image toFavorites:(SADataStore *)dataStore {
    [self saveArtist:artist photo:image];
    [self saveArtist:artist toCoreData:dataStore];
}

+ (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (void)saveArtist:(SAArtist *)artist photo:(UIImage *)image {
    [self createPhotosFolderInDocumentsDirectory:[self documentsDirectory]];
    NSString *imageFileName = [NSString stringWithFormat:@"/Photos/%@", artist.artistSpotifyID];
    NSString *imageFilePath = [[self documentsDirectory] stringByAppendingPathComponent:imageFileName];
    [UIImagePNGRepresentation(image) writeToFile:imageFilePath atomically:YES];
}

+ (void)createPhotosFolderInDocumentsDirectory:(NSString *)documentsDirectory {
    NSError *error = nil;
    NSString *photosDirectory = [documentsDirectory stringByAppendingPathComponent:@"/Photos"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:photosDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:photosDirectory withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

+ (void)saveArtist:(SAArtist *)artist toCoreData:(SADataStore *)dataStore {
    Artist *artistToSave = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:dataStore.managedObjectContext];
    artistToSave.name = artist.artistName;
    artistToSave.imageLocalURL = artist.artistSpotifyID;
    [dataStore save];
}


@end
