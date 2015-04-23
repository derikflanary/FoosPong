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


- (void)requestPurchaseCallback:(void (^)(BOOL *, NSError * error))callback{
    
    [PFPurchase buyProduct:@"teamSubscription" block:^(NSError *error) {
        if (!error) {
            NSLog(@"Purchased");
            [self savePurchaseCallback:^(BOOL *success, NSError *error) {
                if (!error) {
                    callback(success, nil);
                }
            }];
            
            // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
        }
    }];
}

- (void)savePurchaseCallback:(void (^)(BOOL *, NSError * error))callback{
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"subscribed"] = [NSNumber numberWithBool:YES];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            callback(&succeeded, nil);
        }
    }];
    
}

@end
