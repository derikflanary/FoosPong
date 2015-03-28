//
//  RankingsTable.m
//  FoosPong
//
//  Created by Derik Flanary on 3/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "RankingsTable.h"

static NSString * const DifferenceInPointsKey = @"differenceInPoints";
static NSString * const HigherRatedPlayerPercentageKey = @"higherPercentage";
static NSString * const LowerRatedPlayerPercentageKey = @"lowerPercentage";

@implementation RankingsTable

+ (NSNumber *)higherRatedPlayerPercentageAtIndex:(NSInteger)index{
    
    return [self winningExpectanciesTable][index][HigherRatedPlayerPercentageKey];
    
}

+ (NSNumber *)lowerRatedPlayerAtIndex:(NSInteger)index{
    
    return [self winningExpectanciesTable][index][LowerRatedPlayerPercentageKey];
}


+ (NSArray *) pointDifferences{
    
    return @[@0,@25,@50,@75,@100,@150,@200,@250,@300,@350,@400,@450,@500,@600,@700,@800,@900,@1000,@1100,@1200,@1300,@1400,@1500,@1600,@1700,@1800];

}

+ (NSArray *) winningExpectanciesTable {
    
    return @[
             @{  DifferenceInPointsKey : @0,
                 HigherRatedPlayerPercentageKey : @50,
                 LowerRatedPlayerPercentageKey : @50
                 },
             @{  DifferenceInPointsKey : @25,
                 HigherRatedPlayerPercentageKey : @51,
                 LowerRatedPlayerPercentageKey : @49
                 },
             @{  DifferenceInPointsKey : @50,
                 HigherRatedPlayerPercentageKey : @53,
                 LowerRatedPlayerPercentageKey : @47
                 },
             @{  DifferenceInPointsKey : @75,
                 HigherRatedPlayerPercentageKey : @54,
                 LowerRatedPlayerPercentageKey : @46
                 },
             @{  DifferenceInPointsKey : @100,
                 HigherRatedPlayerPercentageKey : @56,
                 LowerRatedPlayerPercentageKey : @44
                 },
             @{  DifferenceInPointsKey : @150,
                 HigherRatedPlayerPercentageKey : @59,
                 LowerRatedPlayerPercentageKey : @41
                 },
             @{  DifferenceInPointsKey : @200,
                 HigherRatedPlayerPercentageKey : @61,
                 LowerRatedPlayerPercentageKey : @39
                 },
             @{  DifferenceInPointsKey : @250,
                 HigherRatedPlayerPercentageKey : @64,
                 LowerRatedPlayerPercentageKey : @36
                 },
             @{  DifferenceInPointsKey : @300,
                 HigherRatedPlayerPercentageKey : @67,
                 LowerRatedPlayerPercentageKey : @33
                 },
             @{  DifferenceInPointsKey : @350,
                 HigherRatedPlayerPercentageKey : @69,
                 LowerRatedPlayerPercentageKey : @31
                 },
             @{  DifferenceInPointsKey : @400,
                 HigherRatedPlayerPercentageKey : @72,
                 LowerRatedPlayerPercentageKey : @28
                 },
             @{  DifferenceInPointsKey : @450,
                 HigherRatedPlayerPercentageKey : @74,
                 LowerRatedPlayerPercentageKey : @26
                 },
             @{  DifferenceInPointsKey : @500,
                 HigherRatedPlayerPercentageKey : @76,
                 LowerRatedPlayerPercentageKey : @24
                 },
             @{  DifferenceInPointsKey : @600,
                 HigherRatedPlayerPercentageKey : @80,
                 LowerRatedPlayerPercentageKey : @20
                 },
             @{  DifferenceInPointsKey : @700,
                 HigherRatedPlayerPercentageKey : @83,
                 LowerRatedPlayerPercentageKey : @17
                 },
             @{  DifferenceInPointsKey : @800,
                 HigherRatedPlayerPercentageKey : @86,
                 LowerRatedPlayerPercentageKey : @14
                 },
             @{  DifferenceInPointsKey : @900,
                 HigherRatedPlayerPercentageKey : @89,
                 LowerRatedPlayerPercentageKey : @11
                 },
             @{  DifferenceInPointsKey : @1000,
                 HigherRatedPlayerPercentageKey : @91,
                 LowerRatedPlayerPercentageKey : @9
                 },
             @{  DifferenceInPointsKey : @1100,
                 HigherRatedPlayerPercentageKey : @93,
                 LowerRatedPlayerPercentageKey : @7
                 },
             @{  DifferenceInPointsKey : @1200,
                 HigherRatedPlayerPercentageKey : @94,
                 LowerRatedPlayerPercentageKey : @6
                 },
             @{  DifferenceInPointsKey : @1300,
                 HigherRatedPlayerPercentageKey : @95,
                 LowerRatedPlayerPercentageKey : @5
                 },
             @{  DifferenceInPointsKey : @1400,
                 HigherRatedPlayerPercentageKey : @96,
                 LowerRatedPlayerPercentageKey : @4
                 },
             @{  DifferenceInPointsKey : @1500,
                 HigherRatedPlayerPercentageKey : @97,
                 LowerRatedPlayerPercentageKey : @3
                 },
             @{  DifferenceInPointsKey : @1600,
                 HigherRatedPlayerPercentageKey : @98,
                 LowerRatedPlayerPercentageKey : @2
                 },
             @{  DifferenceInPointsKey : @1700,
                 HigherRatedPlayerPercentageKey : @98,
                 LowerRatedPlayerPercentageKey : @2
                 },
             @{  DifferenceInPointsKey : @1800,
                 HigherRatedPlayerPercentageKey : @99,
                 LowerRatedPlayerPercentageKey : @1
                 },
             
            ];
}

@end