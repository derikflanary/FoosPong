//
//  TeamGame.h
//  FoosPong
//
//  Created by Derik Flanary on 3/4/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Parse/Parse.h>

@interface TeamGame : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property PFUser *teamOneAttacker;
@property PFUser *teamOneDefender;
@property PFUser *teamTwoAttacker;
@property PFUser *teamTwoDefender;
@property double teamOneScore;
@property double teamTwoScore;
@property NSNumber *teamOneWin;
@property PFObject *group;
@property NSNumber *tenPointGame;

@end
