//
//  TeamGameController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamGameController.h"
#import "TeamGame.h"
#import "RankingController.h"

@interface TeamGameController()


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


- (void)addGameWithTeamGameStats:(TeamGameDetails*)gameStats callback:(void (^)(TeamGameDetails *))callback{

    TeamGame *finishedGame = [TeamGame object];
    
    finishedGame.teamOneAttacker = gameStats.teamOneAttacker;
    finishedGame.teamOneDefender = gameStats.teamOneDefender;
    finishedGame.teamTwoAttacker = gameStats.teamTwoAttacker;
    finishedGame.teamTwoDefender = gameStats.teamTwoDefender;
    finishedGame.teamOneScore = gameStats.teamOneScore;
    finishedGame.teamTwoScore = gameStats.teamTwoScore;
    finishedGame.teamOneWin = [NSNumber numberWithBool:gameStats.teamOneWin];
    finishedGame.group = gameStats.group;
    finishedGame.tenPointGame = [NSNumber numberWithBool:gameStats.tenPointGame];
    
    [[RankingController sharedInstance]updateNewRankingsForTeamGame:gameStats callback:^(NSArray *teamOneNewRanks, NSArray *teamTwoNewRanks) {
        PFObject *rank1 = [teamOneNewRanks firstObject];
        gameStats.teamOneAttackerNewRank = rank1[@"rank"];
        PFObject *rank2 = [teamOneNewRanks lastObject];
        gameStats.teamOneDefenderNewRank = rank2[@"rank"];
        PFObject *rank3 = [teamTwoNewRanks firstObject];
        gameStats.teamTwoAttackerNewRank = rank3[@"rank"];
        PFObject *rank4 = [teamTwoNewRanks lastObject];
        gameStats.teamTwoDefenderNewRank = rank4[@"rank"];
        
        
        [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Team Game Saved");
                callback(gameStats);
            }else
                NSLog(@"%@", error);
        }];
    }];
    
    
}

-(void)updateGamesForUser:(PFUser*)user callback:(void (^)(NSArray *))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"TeamGame"];
    [query whereKey:@"teamOneAttacker" equalTo:user];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamOneDefender" equalTo:user];
    
    PFQuery *query3 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamTwoAttacker" equalTo:user];
    
    PFQuery *query4 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamTwoDefender" equalTo:user];
    
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2, query3, query4]];
    [theQuery includeKey:@"teamOneAttacker"];
    [theQuery includeKey:@"teamOneDefender"];
    [theQuery includeKey:@"teamTwoAttacker"];
    [theQuery includeKey:@"teamTwoDefender"];
    [theQuery orderByDescending:@"createdAt"];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.teamGames = objects;
            callback(objects);
            
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)updateGamesForGroup:(PFObject*)group Callback:(void (^)(NSArray *))callback{
 
    PFQuery *query = [PFQuery queryWithClassName:@"TeamGame"];
    [query whereKey:@"group" equalTo:group];
    
    PFQuery *query2 = [PFQuery orQueryWithSubqueries:@[query]];
    [query2 includeKey:@"teamOneAttacker"];
    [query2 includeKey:@"teamOneDefender"];
    [query2 includeKey:@"teamTwoDefender"];
    [query2 includeKey:@"teamTwoAttacker"];
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"TeamGame"];
    [query whereKey:@"teamOneAttacker" equalTo:user];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamOneDefender" equalTo:user];
    
    PFQuery *query3 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamTwoAttacker" equalTo:user];
    
    PFQuery *query4 = [PFQuery queryWithClassName:@"TeamGame"];
    [query2 whereKey:@"teamTwoDefender" equalTo:user];
    
    bool tenPointGames = [[NSUserDefaults standardUserDefaults]boolForKey:@"tenPointGamesOn"];
    //    BOOL tenPointGames = tenPointGame.boolValue;
    
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2, query3, query4]];
    if (tenPointGames) {
        [theQuery whereKey:@"tenPointGame" equalTo:[NSNumber numberWithBool:tenPointGames]];
        
    }else{
        [theQuery whereKey:@"tenPointGame" equalTo:[NSNumber numberWithBool:tenPointGames]];
    }
    [theQuery whereKey:@"group" equalTo:group];
    [theQuery includeKey:@"teamOneAttacker"];
    [theQuery includeKey:@"teamOneDefender"];
    [theQuery includeKey:@"teamTwoAttacker"];
    [theQuery includeKey:@"teamTwoDefender"];
    [theQuery orderByDescending:@"createdAt"];
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
