//
//  RankingController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "RankingController.h"
#import "UserController.h"

static int const konstant = 50;

@interface RankingController()

@property (nonatomic, assign) int rankingDiff;
@property (nonatomic, assign) double realDifference;

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

- (void)updateNewRankingsForWinner:(PFUser*)winner andLoser:(PFUser*)loser callback:(void (^)(NSNumber *winnerNewRank, NSNumber *loserNewRank))callback{
    
    //r'(1) = r(1) + K * (S(1) – E(1))
    
    NSNumber *winnerRanking = winner[@"ranking"];
    NSNumber *loserRanking = loser[@"ranking"];
    double winnerRankDouble = [winnerRanking doubleValue];
    double loserRankDouble = [loserRanking doubleValue];
    
    BOOL winnerIsHigherRanked;
    
    if (winnerRankDouble > loserRankDouble) {
        self.rankingDiff = winnerRankDouble - loserRankDouble;
        winnerIsHigherRanked = YES;
    }else{
        self.rankingDiff = loserRankDouble - winnerRankDouble;
        winnerIsHigherRanked = NO;
    }
    
    if (self.rankingDiff == 0) {
        self.realDifference = 0;
        
    }else if (self.rankingDiff < 26) {
        self.realDifference = 25;

    }else if (self.rankingDiff < 51){
        self.realDifference = 50;
        
    }else if (self.rankingDiff < 76){
        self.realDifference = 75;
        
    }else if (self.rankingDiff < 101){
        self.realDifference = 100;
        
    }else if (self.rankingDiff < 501){
       self.realDifference = 50.0 * floor((self.rankingDiff/50.0)+0.5);
    
    }else{
        
        double deci = self.rankingDiff % 100;//43
        
        if(deci > 49){
            self.realDifference = self.rankingDiff - deci + 100; //543-43+100 =600
        }
        else{
            self.realDifference = self.rankingDiff - deci;
        }
    }
    
    NSArray *diffArray = [RankingsTable pointDifferences];
    
    NSUInteger idx = [diffArray indexOfObject:[NSNumber numberWithDouble:self.realDifference]];
//    NSUInteger idx = [diffArray indexOfObject:[NSString stringWithFormat:@"%f", self.realDifference]];
    float winnerPercentage;
    float loserPercentage;

    if (winnerIsHigherRanked) {
        winnerPercentage = [[RankingsTable higherRatedPlayerPercentageAtIndex:idx] doubleValue] / 100;
        loserPercentage = [[RankingsTable lowerRatedPlayerAtIndex:idx] doubleValue] / 100;
    
    }else{
        winnerPercentage = [[RankingsTable lowerRatedPlayerAtIndex:idx] doubleValue] / 100;
        loserPercentage = [[RankingsTable higherRatedPlayerPercentageAtIndex:idx] doubleValue] / 100;
        
    }
    
    double winnerNewRank = winnerRankDouble + konstant * (1 - winnerPercentage);
    
    double loserNewRank = loserRankDouble + konstant * (0 - loserPercentage);
    
    //round the floats to doubles and call them back.
    
    NSNumber *newWinnerRank = [NSNumber numberWithDouble:winnerNewRank];
    NSNumber *newLoserRank = [NSNumber numberWithDouble:loserNewRank];
    
    winner[@"ranking"] = newWinnerRank;
    loser[@"ranking"] = newLoserRank;
    
    [winner saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [loser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    callback(newWinnerRank, newLoserRank);
                }else{
                    NSLog(@"%@", error);
                }
            }];
        }else{
            NSLog(@"%@", error);
        }
    }];
    
    
    //r'(1) = r(1) + K * (S(1) – E(1))
}


@end
