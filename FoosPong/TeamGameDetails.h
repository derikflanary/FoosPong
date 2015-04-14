//
//  TeamGameStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamGameDetails : NSObject

@property (nonatomic, strong) PFUser *teamOneAttacker;
@property (nonatomic, strong) PFUser *teamOneDefender;
@property (nonatomic, strong) PFUser *teamTwoAttacker;
@property (nonatomic, strong) PFUser *teamTwoDefender;
@property (nonatomic, assign) double teamOneScore;
@property (nonatomic, assign) double teamTwoScore;
@property (nonatomic, assign) BOOL teamOneWin;
@property (nonatomic, assign) NSInteger teamGameWins;
@property (nonatomic, assign) NSInteger teamGameLoses;
@property (nonatomic, assign) NSInteger teamGamesPlayed;
@property (nonatomic, strong) PFObject *group;

@property (nonatomic, strong) NSNumber *teamOneAttackerStartingRank;
@property (nonatomic, strong) NSNumber *teamOneDefenderStartingRank;
@property (nonatomic, strong) NSNumber *teamTwoAttackerStartingRank;
@property (nonatomic, strong) NSNumber *teamTwoDefenderStartingRank;

@property (nonatomic, strong) NSNumber *teamOneAttackerNewRank;
@property (nonatomic, strong) NSNumber *teamOneDefenderNewRank;
@property (nonatomic, strong) NSNumber *teamTwoAttackerNewRank;
@property (nonatomic, strong) NSNumber *teamTwoDefenderNewRank;

@property (nonatomic, assign) BOOL tenPointGame;

@end
