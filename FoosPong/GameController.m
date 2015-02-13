//
//  GameController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GameController.h"

@interface GameController()

@property(nonatomic, strong)NSArray *games;

@end

@implementation GameController


+ (GameController *)sharedInstance {
    static GameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameController alloc] init];
        
    });
    return sharedInstance;
}


-(void)addGame{
    
}

-(NSArray*)games{
    NSArray *array = [NSArray array];
    return array;
}

-(void)removeGame:(PFObject*)game{
    
}

-(void)saveGames{
    
}

@end
