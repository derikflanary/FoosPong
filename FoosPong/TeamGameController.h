//
//  TeamGameController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamGameStats.h"

@interface TeamGameController : NSObject

+ (TeamGameController *)sharedInstance;
- (void)addGameWithSingleGameStats:(TeamGameStats*)gameStats;
- (void)updateGamesForUser:(PFUser*)user callback:(void (^)(NSArray *))callback;

@end
