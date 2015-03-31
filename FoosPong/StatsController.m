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
    
    NSCountedSet* stringSet = [[NSCountedSet alloc] initWithArray:stats.opponents];
    PFUser* mostCommon = nil;
    NSUInteger highestCount = 0;
    
    for(PFUser* user in stringSet) {
        NSUInteger count = [stringSet countForObject:user];
        if(count > highestCount) {
            highestCount = count;
            mostCommon = user;
        }
    }
    
    stats.statArray = @[[NSNumber numberWithLong:stats.singleGamesPlayed],
                        [NSNumber numberWithLong:stats.singleGameWins],
                        [NSNumber numberWithLong:stats.singleGameLoses],
                        [NSNumber numberWithFloat:stats.pointsPerGame],
                        [NSNumber numberWithFloat:stats.pointsAllowedPerGame],
                        mostCommon[@"firstName"],
                        @[@"Single Game Wins", @"Single Game Loses", @"Single Games Played", @"Points Scored Per Game", @"Points Allowed Per Game", @"Favorite Opponent"]];

    
//    stats.statArray = @[@{@"singleGameWins": [NSNumber numberWithLong:stats.singleGameWins]},
//                        @{@"singleGameLoses": [NSNumber numberWithLong:stats.singleGameLoses]},
//                        @{@"singleGamesPlayed": [NSNumber numberWithLong:stats.singleGamesPlayed]},
//                        @{@"pointsPerGame": [NSNumber numberWithFloat:stats.pointsPerGame]},
//                        @{@"pointsAllowedPerGame": [NSNumber numberWithFloat:stats.pointsAllowedPerGame]},
//                        @{@"opponents": stats.opponents},
//                        @[@"Single Game Wins", @"Single Game Loses", @"Single Games Played", @"Points Per Game", @"Points Allowed Per Game", @"Favorite Opponent"]];
//    
    
    callback(stats);
    
}

- (void) retrieveTeamStatsForUser:(PFUser*)user andTeamGames:(NSArray*)teamGames callback:(void (^)(PersonalTeamStats *))callback{
    
    PersonalTeamStats *stats = [PersonalTeamStats new];
    stats.teamGamesPlayed = [teamGames count];
    NSMutableArray *mutableOpponents = [NSMutableArray array];
    
    for (TeamGame *teamGame in teamGames) {
        
        if (teamGame.teamOneAttacker == user || teamGame.teamOneDefender == user) {
            if ([teamGame.teamOneWin boolValue]) {
                stats.teamGameWins ++;
                stats.pointsScored = stats.pointsScored + teamGame.teamOneScore;
                stats.pointsAllowed = stats.pointsAllowed + teamGame.teamTwoScore;
                [mutableOpponents addObjectsFromArray: @[teamGame.teamTwoAttacker, teamGame.teamOneDefender]];
            }else{
                stats.teamGameLoses ++;
                stats.pointsScored = stats.pointsScored + teamGame.teamOneScore;
                stats.pointsAllowed = stats.pointsAllowed + teamGame.teamTwoScore;
                [mutableOpponents addObjectsFromArray: @[teamGame.teamTwoAttacker, teamGame.teamOneDefender]];
            }
            
        }else if (teamGame.teamTwoAttacker == user || teamGame.teamTwoDefender == user){
            if ([teamGame.teamOneWin boolValue]) {
                stats.teamGameLoses ++;
                stats.pointsScored = stats.pointsScored + teamGame.teamTwoScore;
                stats.pointsAllowed = stats.pointsAllowed + teamGame.teamOneScore;
                [mutableOpponents addObjectsFromArray: @[teamGame.teamOneAttacker, teamGame.teamOneDefender]];
            }else{
                stats.teamGameWins ++;
                stats.pointsScored = stats.pointsScored + teamGame.teamTwoScore;
                stats.pointsAllowed = stats.pointsAllowed + teamGame.teamOneScore;
                [mutableOpponents addObjectsFromArray: @[teamGame.teamOneAttacker, teamGame.teamOneDefender]];
            }
        }
    }
    stats.opposingTeams = mutableOpponents;
    stats.pointsScoredPerGame = (float)stats.pointsScored/(float)stats.teamGamesPlayed;
    stats.pointsAllowedPerGame = (float)stats.pointsAllowed / (float)stats.teamGamesPlayed;
    stats.teamStatsArray = @[[NSNumber numberWithInteger:stats.teamGamesPlayed],
                             [NSNumber numberWithInteger:stats.teamGameWins],
                             [NSNumber numberWithInteger:stats.teamGameLoses],
                             [NSNumber numberWithFloat:stats.pointsScoredPerGame],
                             [NSNumber numberWithFloat:stats.pointsAllowedPerGame],
                             @[@"Team Games Played",
                               @"Team Game Wins",
                               @"Team Game Loses",
                               @"Points Scored Per Game",
                               @"Points Allowed Per Game"]];
    
    callback(stats);
}

- (void) retrieveOverallStatsForUser:(PFUser*)user andSingleGames:(NSArray*)singleGames andTeamGames:(NSArray*)teamGames callback:(void (^)(PersonalOverallStats *))callback{
    
    PersonalOverallStats *stats = [PersonalOverallStats new];
   
    stats.totalGamesPlayed = [singleGames count] + [teamGames count];
    stats.singleGamesPlayed = [singleGames count];
    stats.teamGamesPlayed = [teamGames count];
    
    for (Game *singleGame in singleGames) {
        
        if ([singleGame.p1.objectId isEqualToString:user.objectId] && [singleGame.playerOneWin boolValue]) {
            stats.wins ++;
            
        }else if ([singleGame.p1.objectId isEqualToString: user.objectId] && ![singleGame.playerOneWin boolValue]){
            stats.loses ++;
            
        }else if ([singleGame.p2.objectId isEqualToString: user.objectId] && ![singleGame.playerOneWin boolValue]){
            stats.wins ++;
            
        }else{
            stats.loses ++;
        }
    }
    
    for (TeamGame *teamGame in teamGames) {
        
        if ([teamGame.teamOneAttacker.objectId isEqualToString: user.objectId] || [teamGame.teamOneDefender.objectId isEqualToString: user.objectId]) {
            if ([teamGame.teamOneWin boolValue]) {
                stats.wins ++;
                
            }else{
                stats.loses ++;
            }
            
        }else if ([teamGame.teamTwoAttacker.objectId isEqualToString: user.objectId] || [teamGame.teamTwoDefender.objectId isEqualToString: user.objectId]){
            if ([teamGame.teamOneWin boolValue]) {
                stats.loses ++;
                
            }else{
                stats.wins ++;
            }
        }
    }
    
    stats.overallStatsArray = @[[NSNumber numberWithInteger:stats.totalGamesPlayed],
                                [NSNumber numberWithInteger:stats.wins],
                                [NSNumber numberWithInteger:stats.loses],
                                [NSNumber numberWithInteger:stats.singleGamesPlayed],
                                [NSNumber numberWithInteger:stats.teamGamesPlayed],
                                @[@"Games Played",
                                  @"Wins",
                                  @"Loses",
                                  @"1V1 Games Played",
                                  @"2V2 Games Played"]];
    
    callback(stats);


    
    
}



@end
