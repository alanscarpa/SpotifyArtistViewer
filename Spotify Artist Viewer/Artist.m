//
//  Artist.m
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import "Artist.h"
#import "Album.h"
#import "Song.h"

NSString *const kArtistEntityName = @"Artist";

@implementation Artist

- (Album *)albumWithSpotifyID:(NSString *)spotifyID {
    for (Album *album in self.albums) {
        if ([album.spotifyID isEqualToString:spotifyID]) {
            return album;
        }
    }
    return nil;
}

///////
//+ (NSArray *)albumsFromDictionary:(NSDictionary *)JSONDictionary forArtist:(Artist *)artist {
//    for (NSDictionary *dictionary in JSONDictionary[@"items"]) {
//        if (![self doesArtist:artist alreadyHaveAlbum:dictionary]) {
//            Album *newAlbum = [[SADataStore sharedDataStore] insertNewAlbum];
//            [self updateArtist:artist withAlbum:newAlbum fromDictionary:dictionary];
//            [artist addAlbumsObject:newAlbum];
//        }
//    }
//    return [artist albumsSortedByName];
//}
//
//+ (BOOL)doesArtist:(Artist *)artist alreadyHaveAlbum:(NSDictionary *)dictionary {
//    for (Album *album in [artist.albums allObjects]) {
//        if ([dictionary[@"id"] isEqualToString:album.spotifyID]) {
//            [self updateArtist:artist withAlbum:album fromDictionary:dictionary];
//            return YES;
//        }
//    }
//    return NO;
//}
//
//+ (void)updateArtist:(Artist *)artist withAlbum:(Album *)album fromDictionary:(NSDictionary *)dictionary {
//    album.name = dictionary[@"name"];
//    album.spotifyID = dictionary[@"id"];
//    if ([dictionary[@"images"] count]>0) {
//        album.imageLocalURL = dictionary[@"images"][0][@"url"];
//    }
//}
//
//- (Album *)albumWithSpotifyID:(NSString *)spotifyID {
//    for (Song *song in self.songs) {
//        if ([song.spotifyID isEqualToString:spotifyID]) {
//            return song;
//        }
//    }
//    return nil;
//}

/////////////
- (NSArray *)albumsSortedByName {
    return [[self.albums allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
}

@end
