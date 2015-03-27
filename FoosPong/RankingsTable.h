//
//  RankingsTable.h
//  FoosPong
//
//  Created by Derik Flanary on 3/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface RankingsTable : NSObject

+ (NSNumber *)higherRatedPlayerPercentageAtIndex:(NSInteger)index;
+ (NSNumber *)lowerRatedPlayerAtIndex:(NSInteger)index;
+ (NSArray *) pointDifferences;

@end


