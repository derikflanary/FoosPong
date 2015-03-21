//
//  GameController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SingleGameController.h"
#import "TeamGameController.h"
#import "Game.h"

@interface SingleGameController()

@property(nonatomic, strong)NSArray *games;


@end

@implementation SingleGameController


+ (SingleGameController *)sharedInstance {
    static SingleGameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SingleGameController alloc] init];
        
    });
    return sharedInstance;
}


-(void)addGameWithSingleGameStats:(SingleGameStats*)gameStats{
    
    Game *finishedGame = [Game object];
    finishedGame.p1 = gameStats.playerOne;
    finishedGame.p2 = gameStats.playerTwo;
    finishedGame.playerOneScore = gameStats.playerOneScore;
    finishedGame.playerTwoScore = gameStats.playerTwoScore;
    finishedGame.playerOneWin = [NSNumber numberWithBool: gameStats.playerOneWin];
    
    [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Single Game Saved");
        }else
            NSLog(@"%@", error);
    }];
}


-(void)updateGamesForUser:(PFUser*)user withBool:(BOOL)getTeamGames callback:(void (^)(NSArray *))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"p1" equalTo:user];
    //[query includeKey:@"p1"];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Game"];
    [query2 whereKey:@"p2" equalTo:user];
    //[query2 includeKey:@"p2"];
    
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [theQuery includeKey:@"p1"];
    [theQuery includeKey:@"p2"];
    [theQuery orderByAscending:@"createdAt"];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.games = objects;
            callback(objects);
            
        } else {
    
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    if (getTeamGames == YES) {
        [[TeamGameController sharedInstance] updateGamesForUser:user callback:^(NSArray * teamGames) {
            self.teamGames = teamGames;
        }];
    }
    
}





-(void)removeGame:(PFObject*)game{
    
}

-(void)saveGames{
    
}

@end
