//
//  PersonalOverallStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/9/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalOverallStats : NSObject

@property (nonatomic, assign) NSInteger wins;
@property (nonatomic, assign) NSInteger loses;
@property (nonatomic, assign) NSInteger singleGamesPlayed;
@property (nonatomic, assign) NSInteger teamGamesPlayed;
@property (nonatomic, assign) NSInteger totalGamesPlayed;
@property (nonatomic, strong) NSArray * overallStatsArray;

@end
