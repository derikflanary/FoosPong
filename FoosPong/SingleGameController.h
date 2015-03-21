//
//  GameController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleGameStats.h"

@interface SingleGameController : NSObject

+ (SingleGameController *)sharedInstance;

-(void)removeGame:(PFObject*)game;
-(void)saveGames;
-(void)updateGamesForUser:(PFUser*)user withBool:(BOOL)getTeamGames callback:(void (^)(NSArray *))callback;
-(void)addGameWithSingleGameStats:(SingleGameStats*)gameStats;

@property (nonatomic, strong, readonly)NSArray *games;
@property(nonatomic, strong)NSArray *teamGames;

@end
