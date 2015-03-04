//
//  TeamGameController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamGameController.h"

@interface TeamGameController()

@property(nonatomic, strong)NSArray *teamGames;

@end


@implementation TeamGameController


+ (TeamGameController *)sharedInstance {
    static TeamGameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TeamGameController alloc] init];
        
    });
    return sharedInstance;
}


-(void)addGameWithTeamGameStats:(TeamGameStats*)gameStats{
    PFObject *finishedGame = [PFObject objectWithClassName:@"TeamGame"];
    
    finishedGame[@"teamOnePlayerOne"] = gameStats.teamOnePlayerOne;
    finishedGame[@"teamOnePlayerTwo"] = gameStats.teamOnePlayerTwo;
    finishedGame[@"teamTwoPlayerOne"] = gameStats.teamTwoPlayerOne;
    finishedGame[@"teamTwoPlayerTwo"] = gameStats.teamTwoPlayerTwo;
    finishedGame[@"teamOneScore"] = @(gameStats.teamOneScore);
    finishedGame[@"teamTwoScore"] = @(gameStats.teamTwoScore);
    finishedGame[@"teamOneWin"] = gameStats.teamOneWin;
    
    [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Single Game Saved");
        }else
            NSLog(@"%@", error);
    }];
}

-(void)updateGamesForUser:(PFUser*)user callback:(void (^)(NSArray *))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"TeamGame"];
    [query whereKey:@"teamOnePlayerOne" equalTo:user];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamOnePlayerTwo" equalTo:user];
    
    PFQuery *query3 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamTwoPlayerOne" equalTo:user];
    
    PFQuery *query4 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamTwoPlayerTwo" equalTo:user];
    
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2, query3, query4]];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.teamGames = objects;
            callback(objects);
            
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(void)removeGame:(PFObject*)game{
    
}

-(void)saveGames{
    
}


@end
