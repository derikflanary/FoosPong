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
static NSString * const rankingClassKey = @"Ranking";
static NSString * const rankKey = @"rank";
static NSString * const rankHistoryKey = @"rankHistory";

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

- (void)createRankingforUser:(PFUser*)user forGroup:(PFObject *)group withCallback:(void (^)(BOOL * itSucceeded))callback{
    
    PFObject *ranking = [PFObject objectWithClassName:rankingClassKey];
    ranking[rankKey] = @1000;
    ranking[@"user"] = user;
    ranking[@"group"] = group;
    ranking[rankHistoryKey] = @[@1000];
    [ranking saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            user[@"rankings"] = @[ranking];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                callback(&succeeded);
            }];
            
        }else{
            NSLog(@"%@", error);
        }
    }];
    
}


- (void)setNewRankingWithCallback:(void (^)(BOOL * succeeded))callback{
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *currentGroup = currentUser[@"currentGroup"];
    
    PFQuery *query = [PFQuery queryWithClassName:rankingClassKey];
    [query whereKey:@"group" equalTo:currentGroup.objectId];
    [query whereKey:@"user" equalTo:currentUser.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            currentUser[@"ranking"] = object;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    callback(&succeeded);
                }else{
                    NSLog(@"%@", error);
                }
            }];
        }
    }];
}


- (void)retrieveRankingsForGroup:(PFObject *)group forUsers:(NSArray *)members withCallBack:(void (^)(NSArray *))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:rankingClassKey];
    [query whereKey:@"group" equalTo:group];
    [query whereKey:@"user" containedIn:members];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            callback(objects);
        }else{
            NSLog(@"Getting rankings for group %@", error);
        }
    }];
    
}


- (void)fetchRankingForUsers:(PFUser *)winner andUser:(PFUser *)loser withCallback:(void (^)(PFObject *winnerRanking, PFObject *loserRanking))callback{
    
    PFObject *ranking = winner[@"ranking"];
    PFObject *loserRanking = loser[@"ranking"];
    
    [ranking fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFObject *fetchedRanking = object;
            [loserRanking fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    PFObject *loserFetchedRanking = object;
                    callback(fetchedRanking, loserFetchedRanking);
                }
            }];
        }
    }];
    
}

- (void)updateNewRankingsForWinner:(PFUser*)winner andLoser:(PFUser*)loser callback:(void (^)(NSNumber *winnerNewRank, NSNumber *loserNewRank))callback{
    
    //r'(1) = r(1) + K * (S(1) – E(1))
    
    [self fetchRankingForUsers:winner andUser:loser withCallback:^(PFObject *winnerRanking, PFObject *loserRanking) {
        
        NSNumber *winnersRanking = winnerRanking[rankKey];
        NSNumber *losersRanking = loserRanking[rankKey];
        
        double winnerRankDouble = [winnersRanking doubleValue];
        double loserRankDouble = [losersRanking doubleValue];
        
        BOOL winnerIsHigherRanked;
        
        if (winnerRankDouble > loserRankDouble) {
            self.rankingDiff = winnerRankDouble - loserRankDouble;
            winnerIsHigherRanked = YES;
        }else{
            self.rankingDiff = loserRankDouble - winnerRankDouble;
            winnerIsHigherRanked = NO;
        }
        
        double winnerPercentage = 0.0;
        double loserPercentage = 0.0;

        
        if (self.rankingDiff == 0) {
            self.realDifference = 0;
            winnerPercentage = .5;
            loserPercentage = .5;
            
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
        
        if (self.realDifference == 0 ) {
            
        }else{
        
            if (winnerIsHigherRanked) {
                NSNumber *winPercentNum = [RankingsTable higherRatedPlayerPercentageAtIndex:idx];
                double winPercentDbl = [winPercentNum doubleValue];
                winnerPercentage = winPercentDbl / 100;
                
                NSNumber *losePercentNum = [RankingsTable higherRatedPlayerPercentageAtIndex:idx];
                double losePercentDbl = [losePercentNum doubleValue];
                loserPercentage = losePercentDbl / 100;
                
            }else{
                NSNumber *winPercentNum = [RankingsTable higherRatedPlayerPercentageAtIndex:idx];
                double winPercentDbl = [winPercentNum doubleValue];
                winnerPercentage = winPercentDbl / 100;
                
                NSNumber *losePercentNum = [RankingsTable higherRatedPlayerPercentageAtIndex:idx];
                double losePercentDbl = [losePercentNum doubleValue];
                loserPercentage = losePercentDbl / 100;
            }
        }
        
        double winnerNewRank = winnerRankDouble + konstant * (1 - winnerPercentage);
        
        double loserNewRank = loserRankDouble + konstant * (0 - loserPercentage);
        
        int roundedWinnerNewRank = (int)winnerNewRank;
        int roundedLoserNewRank =  (int)loserNewRank;
        
        //round the floats to doubles and call them back.
        
        NSNumber *newWinnerRank = [NSNumber numberWithInt:roundedWinnerNewRank];
        NSNumber *newLoserRank = [NSNumber numberWithDouble:roundedLoserNewRank];

        loserRanking[rankKey] = newLoserRank;
        [loserRanking addObject:newLoserRank forKey:rankHistoryKey];
        
        winnerRanking[rankKey] = newWinnerRank;
        [winnerRanking addObject:newWinnerRank forKey:rankHistoryKey];
        
        [winnerRanking saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [loserRanking saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        callback(newWinnerRank, newLoserRank);
                    }else{
                        NSLog(@"%@", error);
                    }
                }];
            }
        }];
        
        
    }];
    
    
    
    
//    winner[@"ranking"] = newWinnerRank;
//    loser[@"ranking"] = newLoserRank;
//    
//    [winner saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            [loser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    callback(newWinnerRank, newLoserRank);
//                }else{
//                    NSLog(@"%@", error);
//                }
//            }];
//        }else{
//            NSLog(@"%@", error);
//        }
//    }];
//    
    
    //r'(1) = r(1) + K * (S(1) – E(1))
}


@end
