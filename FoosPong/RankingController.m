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
            PFObject *doublesRanking = [PFObject objectWithClassName:@"DoublesRanking"];
            doublesRanking[rankKey] = @1000;
            doublesRanking[@"user"] = user;
            doublesRanking[@"group"] = group;
            doublesRanking[rankHistoryKey] = @[@1000];
            [doublesRanking saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    callback(&succeeded);
                }else{
                    NSLog(@"Did not create new doubles ranking %@", error);
                }
                
            }];
//            [user addObject:ranking forKey:@"rankings"];
//            
//            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                callback(&succeeded);
//            }];
            
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

- (void)setNewDoublesRankingWithCallback:(void (^)(BOOL * succeeded))callback{
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *currentGroup = currentUser[@"currentGroup"];
    PFQuery *query = [PFQuery queryWithClassName:@"DoublesRanking"];
    [query whereKey:@"group" equalTo:currentGroup.objectId];
    [query whereKey:@"user" equalTo:currentUser.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            currentUser[@"doublesRanking"] = object;
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
    [query orderByDescending:@"rank"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            callback(objects);
        }else{
            NSLog(@"Getting rankings for group %@", error);
        }
    }];
    
}

- (void)retrieveDoublesRankingsForGroup:(PFObject *)group forUsers:(NSArray *)members withCallBack:(void (^)(NSArray *))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"DoublesRanking"];
    [query whereKey:@"group" equalTo:group];
    [query whereKey:@"user" containedIn:members];
    [query orderByDescending:@"rank"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            callback(objects);
        }else{
            NSLog(@"Getting rankings for group %@", error);
        }
    }];

    
}

- (void)removeRankingForGroup:(PFObject*)group{
    
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:rankingClassKey];
    [query whereKey:@"group" equalTo:group];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFObject *ranking = object;
        [currentUser removeObject:ranking forKey:@"rankings"];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"ranking removed");
            [ranking deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"ranking deleted");
            }];
        }];
        
    }];
    
    
}

- (void)findRankingsForUsers:(PFUser *)winner andUser:(PFUser *)loser withCallback:(void (^)(PFObject *winnerRanking, PFObject *loserRanking))callback{
 
    
    PFQuery *query = [PFQuery queryWithClassName:rankingClassKey];
    [query whereKey:@"user" equalTo:winner];
    PFQuery *query2 = [PFQuery queryWithClassName:rankingClassKey];
    [query2 whereKey:@"user" equalTo:loser];
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *winnerRanking;
        PFObject *loserRanking;
        
        for (PFObject *ranking in objects) {
            PFObject *rankingUser = ranking[@"user"];
            if ([rankingUser.objectId isEqualToString:winner.objectId]) {
                winnerRanking = ranking;
            }else{
                loserRanking = ranking;
            }
        }
        callback(winnerRanking, loserRanking);
    }];
    
}

- (void)updateNewRankingsForWinner:(PFUser*)winner andLoser:(PFUser*)loser callback:(void (^)(NSNumber *winnerNewRank, NSNumber *loserNewRank))callback{
    
    //r'(1) = r(1) + K * (S(1) – E(1))
    
    [self findRankingsForUsers:winner andUser:loser withCallback:^(PFObject *winnerRanking, PFObject *loserRanking) {
        
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
                
                NSNumber *losePercentNum = [RankingsTable lowerRatedPlayerAtIndex:idx];
                double losePercentDbl = [losePercentNum doubleValue];
                loserPercentage = losePercentDbl / 100;
                
            }else{
                NSNumber *winPercentNum = [RankingsTable lowerRatedPlayerAtIndex:idx];
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
    
    //r'(1) = r(1) + K * (S(1) – E(1))
}


- (void)updateNewRankingsForTeamGame:(TeamGameDetails *)teamGameDetails callback:(void (^)(NSArray *teamOneNewRanks, NSArray *teamTwoNewRanks))callback{
    
    double teamOneRanking = [teamGameDetails.teamOneAttackerStartingRank doubleValue] + [teamGameDetails.teamOneDefenderStartingRank doubleValue];
    
    double teamTwoRanking = [teamGameDetails.teamTwoAttackerStartingRank doubleValue] + [teamGameDetails.teamTwoDefenderStartingRank doubleValue];
    
    BOOL winnerIsHigherRanked;

    if (teamGameDetails.teamOneWin) {
        if (teamOneRanking > teamTwoRanking) {
            self.rankingDiff = teamOneRanking - teamTwoRanking;
            winnerIsHigherRanked = YES;
        }else{
            self.rankingDiff = teamTwoRanking - teamOneRanking;
            winnerIsHigherRanked = NO;
        }

    }else{
        if (teamOneRanking > teamTwoRanking) {
            self.rankingDiff = teamOneRanking - teamTwoRanking;
            winnerIsHigherRanked = NO;
        }else{
            self.rankingDiff = teamTwoRanking - teamOneRanking;
            winnerIsHigherRanked = YES;
        }
        
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
            
            NSNumber *losePercentNum = [RankingsTable lowerRatedPlayerAtIndex:idx];
            double losePercentDbl = [losePercentNum doubleValue];
            loserPercentage = losePercentDbl / 100;
            
        }else{
            NSNumber *winPercentNum = [RankingsTable higherRatedPlayerPercentageAtIndex:idx];
            double winPercentDbl = [winPercentNum doubleValue];
            winnerPercentage = winPercentDbl / 100;
            
            NSNumber *losePercentNum = [RankingsTable lowerRatedPlayerAtIndex:idx];
            double losePercentDbl = [losePercentNum doubleValue];
            loserPercentage = losePercentDbl / 100;
        }
    }
    double teamOneNewRank = 0;
    double teamTwoNewRank = 0;
    
    if (teamGameDetails.teamOneWin) {
         teamOneNewRank = teamOneRanking + konstant * (1 - winnerPercentage);
        
         teamTwoNewRank = teamTwoRanking + konstant * (0 - loserPercentage);

    }else{
         teamTwoNewRank = teamTwoRanking + konstant * (1 - winnerPercentage);
        
         teamOneNewRank = teamOneRanking + konstant * (0 - loserPercentage);
    }
    
    int roundedTeamOneNewRankDiff = (int)teamOneNewRank - (int)teamOneRanking;
    int roundedTeamTwoNewRankDiff =  (int)teamTwoNewRank - (int)teamTwoRanking;
    
    //round the floats to doubles and call them back.
    
//    NSNumber *newTeamOneRankDiff = [NSNumber numberWithInt:roundedTeamOneNewRankDiff];
//    NSNumber *newTeamTwoRankDiff = [NSNumber numberWithDouble:roundedTeamTwoNewRankDiff];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DoublesRanking"];
    [query whereKey:@"user" equalTo:teamGameDetails.teamOneAttacker];
    PFQuery *query2 = [PFQuery queryWithClassName:@"DoublesRanking"];
    [query2 whereKey:@"user" equalTo:teamGameDetails.teamOneDefender];
    PFQuery *query3 = [PFQuery queryWithClassName:@"DoublesRanking"];
    [query2 whereKey:@"user" equalTo:teamGameDetails.teamTwoAttacker];
    PFQuery *query4 = [PFQuery queryWithClassName:@"DoublesRanking"];
    [query2 whereKey:@"user" equalTo:teamGameDetails.teamTwoDefender];

    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2,query3, query4]];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        NSMutableArray *teamOneNewRanks = [NSMutableArray arrayWithArray:@[@0, @0]];
//        NSMutableArray *teamTwoNewRanks = [NSMutableArray arrayWithArray:@[@0, @0]];
        PFObject *t1AttackerRank = [PFObject objectWithClassName:@"DoublesRanking"];
        PFObject *t1DefenderRank = [PFObject objectWithClassName:@"DoublesRanking"];
        PFObject *t2AttackerRank = [PFObject objectWithClassName:@"DoublesRanking"];
        PFObject *t2DefenderRank = [PFObject objectWithClassName:@"DoublesRanking"];
        
        
        for (PFObject *doublesRanking in objects) {
            PFObject *rankingUser = doublesRanking[@"user"];
            
            if ([rankingUser.objectId isEqualToString:teamGameDetails.teamOneAttacker.objectId]) {
                t1AttackerRank = doublesRanking;
//                [teamOneNewRanks replaceObjectAtIndex:0 withObject:doublesRanking];
                
            }else if ([rankingUser.objectId isEqualToString:teamGameDetails.teamOneDefender.objectId]){
                t1DefenderRank = doublesRanking;
                
//                [teamOneNewRanks replaceObjectAtIndex:1 withObject:doublesRanking];
            }else if ([rankingUser.objectId isEqualToString:teamGameDetails.teamTwoAttacker.objectId]){
                t2AttackerRank = doublesRanking;
                
//                [teamTwoNewRanks replaceObjectAtIndex:0 withObject:doublesRanking];
            }else{
                t2DefenderRank = doublesRanking;
//                [teamTwoNewRanks replaceObjectAtIndex:1 withObject:doublesRanking];
            }
        }
        
        NSNumber *t1ARank = t1AttackerRank[rankKey];
        int t1ARankInt = [t1ARank intValue] + roundedTeamOneNewRankDiff;
        t1ARank = [NSNumber numberWithInt:t1ARankInt];
        t1AttackerRank[rankKey] = t1ARank;
        [t1AttackerRank addObject:t1ARank forKey:rankHistoryKey];
        
        NSNumber *t1DRank = t1DefenderRank[rankKey];
        int t1DRankInt = [t1DRank intValue] + roundedTeamOneNewRankDiff;
        t1DRank = [NSNumber numberWithInt:t1DRankInt];
        t1DefenderRank[rankKey] = t1DRank;
        [t1DefenderRank addObject:t1DRank forKey:rankHistoryKey];
        
        NSNumber *t2ARank = t2AttackerRank[rankKey];
        int t2ARankInt = [t2ARank intValue] + roundedTeamTwoNewRankDiff;
        t2ARank = [NSNumber numberWithInt:t2ARankInt];
        t2AttackerRank[rankKey] = t2ARank;
        [t2AttackerRank addObject:t2ARank forKey:rankHistoryKey];
        
        NSNumber *t2DRank = t2DefenderRank[rankKey];
        int t2DRankInt = [t2DRank intValue] + roundedTeamTwoNewRankDiff;
        t2DRank = [NSNumber numberWithInt:t2DRankInt];
        t2DefenderRank[rankKey] = t2DRank;
        [t2DefenderRank addObject:t2DRank forKey:rankHistoryKey];
        
        [t1AttackerRank saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           
            [t1DefenderRank saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               
                [t2AttackerRank saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                   
                    [t2DefenderRank saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                       
                        callback(@[t1AttackerRank, t1DefenderRank], @[t2AttackerRank, t2DefenderRank]);
                    }];
                }];
            }];
        }];
        
    }];
    
    }
@end
