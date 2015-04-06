//
//  TeamGameViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamGameViewController : UIViewController

@property (nonatomic, strong) NSArray *teamOne;
@property (nonatomic, strong) NSArray *teamTwo;
@property (nonatomic, strong) NSNumber *teamOneAttackerRank;
@property (nonatomic, strong) NSNumber *teamOneDefenderRank;
@property (nonatomic, strong) NSNumber *teamTwoAttackerRank;
@property (nonatomic, strong) NSNumber *teamTwoDefenderRank;

@end
