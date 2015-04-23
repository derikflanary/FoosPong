//
//  SubscriptionController.h
//  FoosPong
//
//  Created by Derik Flanary on 4/22/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionController : NSObject

+ (SubscriptionController *)sharedInstance;
- (void)requestPurchaseCallback:(void (^)(BOOL *, NSError * error))callback;

@end
