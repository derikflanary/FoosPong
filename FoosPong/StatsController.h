//
//  StatsController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalSingleStats.h"
#import "PersonalTeamStats.h"
#import "PersonalOverallStats.h"

@interface StatsController : NSObject

+ (StatsController *)sharedInstance;
- (void) retrieveSingleStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames callback:(void (^)(PersonalSingleStats *))callback;
- (void) retrieveTeamStatsForUser:(PFUser*)user andTeamGames:(NSArray*)teamGames callback:(void (^)(PersonalTeamStats *))callback;
- (void) retrieveOverallStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames andTeamGames:(NSArray*)teamGames callback:(void (^)(PersonalOverallStats *))callback;
- (void)retrieveGuestGameStatsWithGuestGames:(NSArray *)guestGames callback:(void (^)(PersonalOverallStats *))callback;


@end
