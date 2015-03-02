//
//  TeamGameController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamGameController.h"

@implementation TeamGameController


+ (TeamGameController *)sharedInstance {
    static TeamGameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TeamGameController alloc] init];
        
    });
    return sharedInstance;
}


-(void)addGameWithSingleGameStats:(TeamGameStats*)gameStats{
    PFObject *finishedGame = [PFObject objectWithClassName:@"TeamGame"];
    
    finishedGame[@"teamOnePlayerOne"] = gameStats.teamOnePlayerOne;
    finishedGame[@"teamOnePlayerTwo"] = gameStats.teamOnePlayerTwo;
    finishedGame[@"teamTwoPlayerOne"] = gameStats.teamTwoPlayerOne;
    finishedGame[@"teamTwoPlayerTwo"] = gameStats.teamTwoPlayerTwo;
    finishedGame[@"teamOneScore"] = gameStats.teamOneScore;
    finishedGame[@"teamTwoScore"] = gameStats.teamTwoScore;
    finishedGame[@"teamOneWin"] = gameStats.teamOneWin;
    
    [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Single Game Saved");
        }else
            NSLog(@"%@", error);
    }];
}

-(void)removeGame:(PFObject*)game{
    
}

-(void)saveGames{
    
}


@end
