//
//  TeamGameController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamGameDetails.h"

@interface TeamGameController : NSObject

+ (TeamGameController *)sharedInstance;
- (void)addGameWithTeamGameStats:(TeamGameDetails*)gameStats;
- (void)updateGamesForUser:(PFUser*)user callback:(void (^)(NSArray *))callback;
- (void)updateGamesForGroup:(PFObject*)group Callback:(void (^)(NSArray *))callback;
- (void)updateGamesForUser:(PFUser *)user forGroup:(PFObject *)group callback:(void (^)(NSArray *))callback;

@property(nonatomic, strong)NSArray *teamGames;

@end
