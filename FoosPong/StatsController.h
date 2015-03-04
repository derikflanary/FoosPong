//
//  StatsController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalStats.h"

@interface StatsController : NSObject

+ (StatsController *)sharedInstance;
- (PersonalStats *) getStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames andTeamGames:(NSArray*)teamGames;

@end
