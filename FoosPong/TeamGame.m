//
//  TeamGame.m
//  FoosPong
//
//  Created by Derik Flanary on 3/4/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamGame.h"

@implementation TeamGame

@dynamic teamOnePlayerOne;
@dynamic teamOnePlayerTwo;
@dynamic teamTwoPlayerOne;
@dynamic teamTwoPlayerTwo;
@dynamic teamOneScore;
@dynamic teamTwoScore;
@dynamic teamOneWin;

+ (void)load {
    [self registerSubclass];
}


+ (NSString *)parseClassName{
    return @"TeamGame";
}

@end
