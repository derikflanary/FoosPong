//
//  RankingController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "RankingController.h"

static int const konstant = 50;

@interface RankingController()

@property (nonatomic, assign) int rankingDiff;
@property (nonatomic, assign) float realDifference;

@end

@implementation RankingController

+ (RankingController *)sharedInstance {
    static RankingController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RankingController alloc] init];
        
    });
    return sharedInstance;
}

- (void)updateNewRankingsForWinner:(PFUser*)winner andLoser:(PFUser*)loser callback:(void (^)(double *winnerNewRank, double *loserNewRank))callback{
    
    //r'(1) = r(1) + K * (S(1) – E(1))
    
    NSNumber *winnerRanking = winner[@"ranking"];
    NSNumber *loserRanking = loser[@"ranking"];
    float winnerRankFloat = [winnerRanking floatValue];
    float loserRankFloat = [loserRanking floatValue];
    
    BOOL winnerIsHigherRanked;
    
    if (winnerRankFloat > loserRankFloat) {
        self.rankingDiff = winnerRankFloat - loserRankFloat;
        winnerIsHigherRanked = YES;
    }else{
        self.rankingDiff = loserRankFloat - winnerRankFloat;
        winnerIsHigherRanked = NO;
    }
    
    if (self.rankingDiff == 0) {
        self.realDifference = 0;
        
    }else if (self.rankingDiff < 25) {
        self.realDifference = 25;

    }else if (self.rankingDiff < 50){
        self.realDifference = 50;
        
    }else if (self.rankingDiff < 75){
        self.realDifference = 75;
        
    }else if (self.rankingDiff < 100){
        self.realDifference = 100;
        
    }else if (self.rankingDiff < 500){
       self.realDifference = 50.0 * floor((self.rankingDiff/50.0)+0.5);
    
    }else{
        float deci = self.rankingDiff % 100;//43
        
        if(deci > 49){
            self.realDifference = self.rankingDiff - deci + 100; //543-43+100 =600
        }
        else{
            self.realDifference = self.rankingDiff - deci;
        }
    }
    
    NSArray *diffArray = [RankingsTable pointDifferences];
    
    NSInteger idx = [diffArray indexOfObject:[NSNumber numberWithFloat:self.realDifference]];
    float winnerPercentage;
    float loserPercentage;
    
    if (winnerIsHigherRanked) {
        winnerPercentage = [[RankingsTable higherRatedPlayerPercentageAtIndex:idx] floatValue];
        loserPercentage = [[RankingsTable lowerRatedPlayerAtIndex:idx] floatValue];
    
    }else{
        winnerPercentage = [[RankingsTable lowerRatedPlayerAtIndex:idx] floatValue];
        loserPercentage = [[RankingsTable higherRatedPlayerPercentageAtIndex:idx] floatValue];
        
    }
    
    float winnerNewRank = winnerRankFloat + konstant * (1 - winnerPercentage);
    
    float loserNewRank = loserRankFloat + konstant * (0 - loserPercentage);
    
    //round the floats to doubles and call them back.
    
    
    //r'(1) = r(1) + K * (S(1) – E(1))
}


@end
