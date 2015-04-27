//
//  GuestGameController.m
//  FoosPong
//
//  Created by Derik Flanary on 4/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GuestGameController.h"

@implementation GuestGameController

+ (GuestGameController *)sharedInstance {
    static GuestGameController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GuestGameController alloc] init];
        
    });
    return sharedInstance;
}


- (void)addGameWithSingleGameStats:(SingleGameDetails*)gameStats andGuestPlayer:(PFObject *)guestPlayer callback:(void (^)(bool))callback{
    
    PFObject *guestGame = [PFObject objectWithClassName:@"GuestSingleGame"];
    if (!gameStats.playerOne.objectId) {
        guestGame[@"p1"] = gameStats.playerTwo;
    }else{
        guestGame[@"p1"] = gameStats.playerOne;
    }
    guestGame[@"guestPlayer"] = guestPlayer;
//    guestGame[@"p2Guest"];
    guestGame[@"playerOneScore"] = [NSNumber numberWithDouble:gameStats.playerOneScore];
    guestGame[@"playerTwoScore"] = [NSNumber numberWithDouble:gameStats.playerTwoScore];
    guestGame[@"playerOneWin"] = [NSNumber numberWithBool: gameStats.playerOneWin];
    guestGame[@"tenPointGame"] = [NSNumber numberWithBool:gameStats.tenPointGame];
    
    [guestGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        callback(succeeded);
        
    }];
}


- (void)addGameWithTeamGameStats:(TeamGameDetails*)gameStats callback:(void (^)(bool))callback{
    
    PFObject *guestGame = [PFObject objectWithClassName:@"GuestSingleGame"];
    guestGame[@"teamOneAttacker"] = gameStats.teamOneAttacker;
    guestGame[@"tenPointGame"] = [NSNumber numberWithBool:gameStats.tenPointGame];
    
    guestGame[@"teamOneDefender"] = gameStats.teamOneDefender;
    guestGame[@"teamTwoAttacker"] = gameStats.teamTwoAttacker;
    guestGame[@"teamTwoDefender"] = gameStats.teamTwoDefender;
    guestGame[@"teamOneScore"] = [NSNumber numberWithDouble:gameStats.teamOneScore];
    guestGame[@"teamTwoScore"] = [NSNumber numberWithDouble:gameStats.teamTwoScore];
    guestGame[@"teamOneWin"] = [NSNumber numberWithBool:gameStats.teamOneWin];

    
    [guestGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        callback(succeeded);
        
    }];
}

@end
