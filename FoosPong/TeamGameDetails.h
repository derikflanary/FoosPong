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
@property (nonatomic, assign) NSNumber *teamOneWin;
@property (nonatomic, assign) NSInteger teamGameWins;
@property (nonatomic, assign) NSInteger teamGameLoses;
@property (nonatomic, assign) NSInteger teamGamesPlayed;
@property (nonatomic, strong)PFObject *group;


@end
