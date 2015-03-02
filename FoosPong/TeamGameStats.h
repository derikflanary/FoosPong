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
@property (nonatomic, assign) NSNumber *teamOneScore;
@property (nonatomic, assign) NSNumber *teamTwoScore;
@property (nonatomic, assign) NSNumber *teamOneWin;



@end
