//
//  SingleGameStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleGameDetails : NSObject

@property (nonatomic, strong) PFUser *playerOne;
@property (nonatomic, strong) PFUser *playerTwo;
@property (nonatomic, assign) double playerOneScore;
@property (nonatomic, assign) double playerTwoScore;
@property (nonatomic, assign) bool playerOneWin;
@property (nonatomic, strong) PFObject *group;
@property (nonatomic, strong) NSNumber *playerOneStartingRank;
@property (nonatomic, strong) NSNumber *playerTwoStartingRank;
@property (nonatomic, strong) NSNumber *playerOneNewRank;
@property (nonatomic, strong) NSNumber *playerTwoNewRank;
@property (nonatomic, assign) BOOL tenPointGame;

@property (nonatomic, assign) BOOL isGuestGame;


@end
