//
//  PersonalTeamStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/9/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalTeamStats : NSObject

@property (nonatomic, assign) NSInteger teamGameWins;
@property (nonatomic, assign) NSInteger teamGameLoses;
@property (nonatomic, assign) NSInteger teamGamesPlayed;
@property (nonatomic, assign) float pointsAllowedPerGame;
@property (nonatomic, assign) float pointsScoredPerGame;
@property (nonatomic, assign) NSInteger pointsScored;
@property (nonatomic, assign) NSInteger pointsAllowed;
@property (nonatomic, strong) NSArray *teamStatsArray;
@property (nonatomic, strong) NSArray *opposingTeams;

@end
