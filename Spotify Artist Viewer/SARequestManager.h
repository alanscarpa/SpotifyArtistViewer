//
//  SARequestManager.h
//  Spotify Artist Viewer
//
//  Created by Alan Scarpa on 9/28/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SARequestManager : NSObject

+(instancetype)sharedManager;

-(void)getArtistsWithQuery:(NSString*)query
                   success:(void (^)(NSDictionary *artists))success
                   failure:(void (^)(NSError *error))failure;

@end
