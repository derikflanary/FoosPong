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
//-(void)addGameWithDictionary:(NSDictionary*)dictionary andUser:(PFUser*)user andOtherUser:(PFUser*)user2;
-(void)removeGame:(PFObject*)game;
-(void)saveGames;
-(void)updateGamesForUser:(PFUser*)user withBool:(BOOL)getTeamGames callback:(void (^)(NSArray *))callback;
-(void)addGameWithSingleGameStats:(SingleGameStats*)gameStats;
- (void)fetchPlayers:(PFUser*)p1 andP2:(PFUser*)p2 withCallback:(void (^)(NSArray *))callback;
@property (nonatomic, strong, readonly)NSArray *games;
@property(nonatomic, strong)NSArray *teamGames;

@end
