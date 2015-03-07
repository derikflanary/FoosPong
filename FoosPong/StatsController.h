//
//  StatsController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalStats.h"
#import "TeamGameStats.h"

@interface StatsController : NSObject

+ (StatsController *)sharedInstance;
- (void) retrieveSingleStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames callback:(void (^)(PersonalStats *))callback;
- (void) retrieveTeamStatsForUser:(PFUser*)user andTeamGames:(NSArray*)teamGames callback:(void (^)(TeamGameStats *))callback;
- (void) retrieveOverallStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames andTeamGames:(NSArray*)teamGames callback:(void (^)(PersonalStats *))callback;


@end
