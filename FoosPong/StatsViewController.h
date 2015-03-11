//
//  StatsViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/6/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalSingleStats.h"
#import "PersonalOverallStats.h"
#import "PersonalTeamStats.h"


@interface StatsViewController : UIViewController

@property (nonatomic, strong) UIImage *copiedImage;
@property (nonatomic, strong) PersonalSingleStats *personalSingleStats;
@property (nonatomic, strong) PersonalTeamStats *personalTeamStats;
@property (nonatomic, strong) PersonalOverallStats *overallStats;
@property (nonatomic, strong) NSArray *games;
@property (nonatomic, assign) NSInteger buttonSelected;

@end
