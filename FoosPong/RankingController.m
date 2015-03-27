//
//  RankingController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "RankingController.h"

@implementation RankingController

+ (RankingController *)sharedInstance {
    static RankingController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RankingController alloc] init];
        
    });
    return sharedInstance;
}


@end
