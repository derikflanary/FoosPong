//
//  PersonalStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalStats : NSObject

@property (nonatomic, assign) NSInteger wins;
@property (nonatomic, assign) NSInteger loses;
@property (nonatomic, assign) NSInteger singleGamesPlayed;
@property (nonatomic, assign) NSInteger teamGamesPlayed;
@property (nonatomic, assign) NSInteger teamGameWins;
@property (nonatomic, assign) NSInteger singleGameWins;
@property (nonatomic, assign) NSInteger totalGamesPlayed;

@end
