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
    stats.singleGamesPlayed = [singleGames count];
    stats.teamGamesPlayed = [teamGames count];
    
    for (Game *singleGame in singleGames) {

        if (singleGame.p1 == user && singleGame.playerOneWin) {
            stats.wins ++;
            stats.singleGameWins ++;
            
        }else if (singleGame.p1 == user && !singleGame.playerOneWin){
            stats.loses ++;

        }else if (singleGame.p2 == user && !singleGame.playerOneWin){
            stats.wins ++;
            stats.singleGameWins ++;
        }else{
            stats.loses ++;
        }
    }
    
    for (TeamGame *teamGame in teamGames) {
    
        if (teamGame.teamOnePlayerOne == user || teamGame.teamOnePlayerTwo == user) {
            if (teamGame.teamOneWin) {
                stats.wins ++;
                stats.teamGameWins ++;
            
            }else{
                stats.loses ++;
                
            }
        
        }else if (teamGame.teamTwoPlayerOne == user || teamGame.teamTwoPlayerTwo == user){
            if (teamGame.teamOneWin) {
                stats.loses ++;
            }else{
                stats.wins ++;
                stats.teamGameWins ++;
            }
        }
    }
    
    return stats;
}


@end
