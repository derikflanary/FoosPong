//
//  StatsController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "StatsController.h"


@implementation StatsController


+ (StatsController *)sharedInstance {
    static StatsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StatsController alloc] init];
        
    });
    return sharedInstance;
}

- (PersonalStats *) getStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames andTeamGames:(NSArray*)teamGames{
    
    PersonalStats *stats = [PersonalStats new];
    stats.gamesPlayed = [singleGames count];
    stats.teamGamesPlayed = [teamGames count];
    
    for (PFObject *singleGame in singleGames) {
        bool p1Win = [singleGame[@"playerOneWin"] boolValue];
        if (singleGame[@"p1"] == user.username && p1Win) {
            stats.wins = stats.wins + 1;
            stats.singleGameWins = stats.singleGameWins + 1;
            
        }else if (singleGame[@"p1"] == user.username && !p1Win){
            stats.loses = stats.loses + 1;

        }else if (singleGame[@"p2"] == user.username && p1Win){
            stats.wins = stats.wins + 1;
            stats.singleGameWins = stats.singleGameWins + 1;
        }else{
            stats.loses = stats.loses + 1;
        }
    }
    
    return stats;
}


@end
