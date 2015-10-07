//
//  SADataStore.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 10/1/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SADataStore : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
+ (instancetype)sharedDataStore;
- (void)save;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)favoritedArtists;

@end
