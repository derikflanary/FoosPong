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


-(void)addGameWithDictionary:(NSDictionary*)dictionary andUser:(PFUser*)user{
    PFObject *finishedGame = [PFObject objectWithClassName:@"Game" dictionary:dictionary];
    finishedGame[@"parent"] = user;
    [finishedGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"saved");
        }else{
            NSLog(@"%@", error);
        }
    }];
}


-(void)updateGamesForUser:(PFUser*)user{
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query getObjectInBackgroundWithId:user.objectId block:^(PFObject *object, NSError *error) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:object];
        self.games = array;

    }];
    }



-(void)removeGame:(PFObject*)game{
    
}

-(void)saveGames{
    
}

@end
