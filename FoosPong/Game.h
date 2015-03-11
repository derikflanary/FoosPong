//
//  Game.h
//  FoosPong
//
//  Created by Derik Flanary on 3/4/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Parse/Parse.h>

@interface Game : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property double playerOneScore;
@property double playerTwoScore;
@property NSNumber *playerOneWin;
@property PFUser *p1;
@property PFUser *p2;


@end
