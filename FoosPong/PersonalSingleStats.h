//
//  PersonalStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalSingleStats : NSObject

@property (nonatomic, assign) NSInteger singleGamesPlayed;
@property (nonatomic, assign) NSInteger singleGameWins;
@property (nonatomic, assign) NSInteger singleGameLoses;
@property (nonatomic, assign) float pointsPerGame;
@property (nonatomic, assign) NSInteger pointsScored;
@property (nonatomic, assign) NSInteger pointsAllowed;
@property (nonatomic, assign) float pointsAllowedPerGame;
@property (nonatomic, strong) NSArray *opponents;


@end
