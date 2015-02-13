//
//  GameController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameController : NSObject
+ (GameController *)sharedInstance;
-(void)addGame;
-(NSArray*)games;
-(void)removeGame:(PFObject*)game;
-(void)saveGames;

@end
