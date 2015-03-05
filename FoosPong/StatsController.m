//
//  StatsController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "StatsController.h"
#import "Game.h"
#import "TeamGame.h"


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
    
    for (Game *singleGame in singleGames) {
        bool p1Win = singleGame.playerOneWin;
        if (singleGame.p1 == user && p1Win) {
            stats.wins = stats.wins + 1;
            stats.singleGameWins = stats.singleGameWins + 1;
            
        }else if (singleGame.p1 == user && !p1Win){
            stats.loses = stats.loses + 1;

        }else if (singleGame.p2 == user && p1Win){
            stats.wins = stats.wins + 1;
            stats.singleGameWins = stats.singleGameWins + 1;
        }else{
            stats.loses = stats.loses + 1;
        }
    }
    
    for (PFObject *teamGame in teamGames) {
        bool t1Win = [teamGame[@"teamOneWin"] boolValue];
        
    }
    
    return stats;
}


@end
