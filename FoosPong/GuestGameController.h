//
//  GuestGameController.h
//  FoosPong
//
//  Created by Derik Flanary on 4/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleGameDetails.h"
#import "TeamGameDetails.h"

@interface GuestGameController : NSObject

+ (GuestGameController *)sharedInstance;
- (void)addGameWithSingleGameStats:(SingleGameDetails*)gameStats andGuestPlayer:(PFObject *)guestPlayer callback:(void (^)(bool))callback;
- (void)updateGuestGamesForUser:(PFUser*)user callback:(void (^)(NSArray *))callback;
- (void)addGameWithTeamGameStats:(TeamGameDetails*)gameStats callback:(void (^)(bool))callback;
- (void)updateGuestTeamGamesForUser:(PFUser*)user callback:(void (^)(NSArray *))callback;

@end
