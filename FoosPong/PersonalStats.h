//
//  PersonalStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/3/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalStats : NSObject

@property (nonatomic, assign) NSNumber *wins;
@property (nonatomic, assign) NSNumber *loses;
@property (nonatomic, assign) NSNumber *gamesPlayed;
@property (nonatomic, assign) NSNumber *teamGamesPlayed;
@property (nonatomic, assign) NSNumber *teamGameWins;
@property (nonatomic, assign) NSNumber *singleGameWins;

@end
