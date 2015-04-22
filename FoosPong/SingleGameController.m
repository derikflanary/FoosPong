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
#import "RankingController.h"

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


-(void)addGameWithSingleGameStats:(SingleGameDetails*)gameStats callback:(void (^)(Game *))callback{
    
    Game *finishedGame = [Game object];
    finishedGame.p1 = gameStats.playerOne;
    finishedGame.p2 = gameStats.playerTwo;
    finishedGame.playerOneScore = gameStats.playerOneScore;
    finishedGame.playerTwoScore = gameStats.playerTwoScore;
    finishedGame.playerOneWin = [NSNumber numberWithBool: gameStats.playerOneWin];
    finishedGame.group = gameStats.group;
    finishedGame.playerOneStartingRank = gameStats.playerOneStartingRank;
    finishedGame.playerTwoStartingRank = gameStats.playerTwoStartingRank;
    finishedGame.tenPointGame = [NSNumber numberWithBool:gameStats.tenPointGame];
    
    
    if (gameStats.playerOneWin) {
        [[RankingController sharedInstance]updateNewRankingsForWinner:gameStats.playerOne andLoser:gameStats.playerTwo callback:^(NSNumber *winnerNewRank, NSNumber *loserNewRank) {
            finishedGame.playerOneNewRank = winnerNewRank;
            finishedGame.playerTwoNewRank = loserNewRank;
            NSLog(@"%@, %@", winnerNewRank, loserNewRank);
            
            [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Single Game Saved");
                    callback(finishedGame);
                }else
                    NSLog(@"%@", error);
            }];
        }];
    
    }else{
        [[RankingController sharedInstance]updateNewRankingsForWinner:gameStats.playerTwo andLoser:gameStats.playerOne callback:^(NSNumber *winnerNewRank, NSNumber *loserNewRank) {
            finishedGame.playerOneNewRank = loserNewRank;
            finishedGame.playerTwoNewRank = winnerNewRank;
            NSLog(@"%@, %@", winnerNewRank, loserNewRank);
            
            [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Single Game Saved");
                    callback(finishedGame);
                }else
                    NSLog(@"%@", error);
            }];
        }];
    }
    
   

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
    [theQuery orderByDescending:@"createdAt"];
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

- (void)updateGamesForGroup:(PFObject*)group Callback:(void (^)(NSArray *))callback{
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Game"];
    [query2 whereKey:@"group" equalTo:group];
    
//    PFQuery *query2 = [PFQuery orQueryWithSubqueries:@[query]];
    [query2 includeKey:@"p1"];
    [query2 includeKey:@"p2"];
    [query2 orderByDescending:@"createdAt"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            callback(objects);
            
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)updateGamesForUser:(PFUser *)user forGroup:(PFObject *)group callback:(void (^)(NSArray *))callback{
    
    PFQuery *query =  [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"p2" equalTo:user];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Game"];
    [query1 whereKey:@"p1" equalTo:user];
    
    NSNumber *tenPointGame = [NSNumber numberWithBool:[[NSUserDefaults standardUserDefaults]objectForKey:@"tenPointGamesOn"]];
    BOOL tenPointGames = tenPointGame.boolValue;
    
//    NSInteger tenGame = [[NSUserDefaults standardUserDefaults]objectForKey:@"tenPointGamesOn"];
    
    
    PFQuery *query2 = [PFQuery orQueryWithSubqueries:@[query, query1]];
    if (tenPointGames) {
        [query2 whereKey:@"tenPointGame" equalTo:tenPointGame];
        
    }else{
        [query2 whereKey:@"tenPointGame" equalTo:tenPointGame];
    }
    [query2 whereKey:@"group" equalTo:group];
    [query2 includeKey:@"p1"];
    [query2 includeKey:@"p2"];
    [query2 orderByDescending:@"createdAt"];
    
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            callback(objects);
            
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

 
    
}

- (void)removeGame:(PFObject*)game{
    
}

- (void)saveGames{
    
}

@end
