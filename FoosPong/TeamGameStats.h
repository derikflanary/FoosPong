//
//  TeamGameStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamGameStats : NSObject

@property (nonatomic, strong) PFUser *teamOnePlayerOne;
@property (nonatomic, strong) PFUser *teamOnePlayerTwo;
@property (nonatomic, strong) PFUser *teamTwoPlayerOne;
@property (nonatomic, strong) PFUser *teamTwoPlayerTwo;
@property (nonatomic, assign) double teamOneScore;
@property (nonatomic, assign) double teamTwoScore;
@property (nonatomic, assign) NSNumber *teamOneWin;
@property (nonatomic, assign) NSInteger teamGameWins;
@property (nonatomic, assign) NSInteger teamGameLoses;
@property (nonatomic, assign) NSInteger teamGamesPlayed;



@end
