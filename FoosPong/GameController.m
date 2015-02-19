//
//  GameController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GameController.h"

static NSString * const playerOneKey = @"playerOneKey";
static NSString * const playerTwoKey = @"playerTwoKey";
static NSString * const playerOneScoreKey = @"playerOneScoreKey";
static NSString * const playerTwoScoreKey = @"playerTwoScoreKey";
static NSString * const playerOneWinKey = @"playerOneWinKey";
static NSString * const playerTwoWinKey = @"playerTwoWinKey";

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

-(void)addGameWithDictionary:(NSDictionary*)dictionary andUser:(PFUser*)user andOtherUser:(PFUser*)user2{
    PFObject *finishedGame = [PFObject objectWithClassName:@"Game"];
    
    finishedGame[@"P1"] = user;
    finishedGame[@"P2"] = user2;
    finishedGame[@"playerOneScore"] = dictionary[playerOneScoreKey];
    finishedGame[@"playerOneWin"] = dictionary[playerOneWinKey];
    finishedGame[@"playerTwoScore"] = dictionary[playerTwoScoreKey];
    finishedGame[@"playerTwoWin"] = dictionary[playerTwoWinKey];
    
    [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved");
        }else{
            NSLog(@"%@", error);
        }
    }];
}


-(void)updateGamesForUser:(PFUser*)user callback:(void (^)(NSArray *))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"P1" equalTo:user];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Game"];
    [query2 whereKey:@"P2" equalTo:user];
    
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.games = objects;
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
