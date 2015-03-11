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

@property PFUser *teamOnePlayerOne;
@property PFUser *teamOnePlayerTwo;
@property PFUser *teamTwoPlayerOne;
@property PFUser *teamTwoPlayerTwo;
@property double teamOneScore;
@property double teamTwoScore;
@property NSNumber *teamOneWin;

@end
