//
//  RankingController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankingController.h"
#import "RankingsTable.h"

@interface RankingController : NSObject

+ (RankingController *)sharedInstance;
- (void)updateNewRankingsForWinner:(PFUser*)winner andLoser:(PFUser*)loser callback:(void (^)(NSNumber *winnerNewRank, NSNumber *loserNewRank))callback;
- (void)createRankingforUser:(PFUser*)user forGroup:(PFObject *)group withCallback:(void (^)(BOOL * itSucceeded))callback;
- (void)setNewRankingWithCallback:(void (^)(BOOL * succeeded))callback;
- (void)retrieveRankingsForGroup:(PFObject *)group forUsers:(NSArray *)members withCallBack:(void (^)(NSArray *))callback;
- (void)removeRankingForGroup:(PFObject*)group;
@end
