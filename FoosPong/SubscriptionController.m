//
//  SubscriptionController.m
//  FoosPong
//
//  Created by Derik Flanary on 4/22/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SubscriptionController.h"

@implementation SubscriptionController

+ (SubscriptionController *)sharedInstance {
    static SubscriptionController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SubscriptionController alloc] init];
        
    });
    return sharedInstance;
}


- (void)requestPurchase{
    
    [PFPurchase buyProduct:@"teamSubscription" block:^(NSError *error) {
        if (!error) {
            // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
        }
    }];
}

@end
