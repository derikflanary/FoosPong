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


@interface StatsController()


@end

@implementation StatsController


+ (StatsController *)sharedInstance {
    static StatsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StatsController alloc] init];
        
    });
    return sharedInstance;
}

- (void) retrieveSingleStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames callback:(void (^)(PersonalSingleStats *))callback{
    
    PersonalSingleStats *stats = [PersonalSingleStats new];
    stats.singleGamesPlayed = [singleGames count];
    NSMutableArray *mutableOpponents = [NSMutableArray array];
    
    for (Game *singleGame in singleGames) {
        
        
        if (singleGame.p1 == user && [singleGame.playerOneWin boolValue]) {
            stats.singleGameWins ++;
            stats.pointsScored = stats.pointsScored + singleGame.playerOneScore;
            stats.pointsAllowed = stats.pointsAllowed + singleGame.playerTwoScore;
            [mutableOpponents addObject:singleGame.p2];
            
        }else if (singleGame.p1 == user && ![singleGame.playerOneWin boolValue]){
            stats.singleGameLoses ++;
            stats.pointsScored = stats.pointsScored + singleGame.playerOneScore;
            stats.pointsAllowed = stats.pointsAllowed + singleGame.playerTwoScore;
            [mutableOpponents addObject:singleGame.p2];
            
        }else if (singleGame.p2 == user && ![singleGame.playerOneWin boolValue]){
            stats.singleGameWins ++;
            stats.pointsScored = stats.pointsScored + singleGame.playerTwoScore;
            stats.pointsAllowed = stats.pointsAllowed + singleGame.playerOneScore;
            [mutableOpponents addObject:singleGame.p1];
            
        }else{
            stats.singleGameLoses ++;
            stats.pointsScored = stats.pointsScored + singleGame.playerTwoScore;
            stats.pointsAllowed = stats.pointsAllowed + singleGame.playerOneScore;
            [mutableOpponents addObject:singleGame.p1];
        }
    }
    stats.opponents = mutableOpponents;
    stats.pointsPerGame = (float)stats.pointsScored/(float)stats.singleGamesPlayed;
    stats.pointsAllowedPerGame = (float)stats.pointsAllowed/(float)stats.singleGamesPlayed;
    callback(stats);
    
}

- (void) retrieveTeamStatsForUser:(PFUser*)user andTeamGames:(NSArray*)teamGames callback:(void (^)(PersonalTeamStats *))callback{
    
    PersonalTeamStats *stats = [PersonalTeamStats new];
    stats.teamGamesPlayed = [teamGames count];
    
    for (TeamGame *teamGame in teamGames) {
        
        if (teamGame.teamOnePlayerOne == user || teamGame.teamOnePlayerTwo == user) {
            if (teamGame.teamOneWin) {
                stats.teamGameWins ++;
                
            }else{
                stats.teamGameLoses ++;
            }
            
        }else if (teamGame.teamTwoPlayerOne == user || teamGame.teamTwoPlayerTwo == user){
            if (teamGame.teamOneWin) {
                stats.teamGameLoses ++;
                
            }else{
                stats.teamGameWins ++;
            }
        }
    }

    callback(stats);
}

- (void) retrieveOverallStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames andTeamGames:(NSArray*)teamGames callback:(void (^)(PersonalOverallStats *))callback{
    
    PersonalOverallStats *stats = [PersonalOverallStats new];
   
    stats.totalGamesPlayed = [singleGames count] + [teamGames count];
    
    for (Game *singleGame in singleGames) {
        
        if (singleGame.p1 == user && singleGame.playerOneWin) {
            stats.wins ++;
            
        }else if (singleGame.p1 == user && !singleGame.playerOneWin){
            stats.loses ++;
            
        }else if (singleGame.p2 == user && !singleGame.playerOneWin){
            stats.wins ++;
            
                    }else{
            stats.loses ++;
        }
    }
    
    for (TeamGame *teamGame in teamGames) {
        
        if (teamGame.teamOnePlayerOne == user || teamGame.teamOnePlayerTwo == user) {
            if (teamGame.teamOneWin) {
                stats.wins ++;
                
            }else{
                stats.loses ++;
            }
            
        }else if (teamGame.teamTwoPlayerOne == user || teamGame.teamTwoPlayerTwo == user){
            if (teamGame.teamOneWin) {
                stats.loses ++;
                
            }else{
                stats.wins ++;
            }
        }
    }

    
    callback(stats);


    
    
}



@end
