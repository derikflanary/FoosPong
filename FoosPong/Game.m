//
//  Game.m
//  FoosPong
//
//  Created by Derik Flanary on 3/4/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "Game.h"

@implementation Game

@dynamic playerOneScore;
@dynamic playerTwoScore;
@dynamic playerOneWin;
@dynamic p1;
@dynamic p2;
@dynamic group;
@dynamic playerOneStartingRank;
@dynamic playerOneNewRank;
@dynamic playerTwoStartingRank;
@dynamic playerTwoNewRank;
@dynamic tenPointGame;

+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName{
    return @"Game";
}

@end

