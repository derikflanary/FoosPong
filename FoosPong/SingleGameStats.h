//
//  SingleGameStats.h
//  FoosPong
//
//  Created by Derik Flanary on 3/2/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleGameStats : NSObject

@property(nonatomic, strong)PFUser *playerOne;
@property(nonatomic, strong)PFUser *playerTwo;
@property(nonatomic, assign)NSNumber *playerOneScore;
@property(nonatomic, assign)NSNumber *playerTwoScore;
@property(nonatomic, assign)NSNumber *playerOneWin;


@end
