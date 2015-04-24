//
//  SubscriptionController.m
//  FoosPong
//
//  Created by Derik Flanary on 4/22/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SubscriptionController.h"

NSString *const kSubscriptionExpirationDateKey = @"ExpirationDate";
NSString *const kSubscriptionNameKey = @"com.derikflanary.Foos.teamSubscription";

@implementation SubscriptionController

+ (SubscriptionController *)sharedInstance {
    static SubscriptionController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSSet * productIdentifiers = [NSSet setWithObjects:
//                                      @"com.derikflanary.Foos.teamSubscription", nil];
        
        sharedInstance = [[SubscriptionController alloc] init];
        
    });
    return sharedInstance;
}


- (void)requestPurchaseCallback:(void (^)(BOOL *, NSError * error))callback{
    
    [PFPurchase buyProduct:kSubscriptionNameKey block:^(NSError *error) {
        if (!error) {
            
            [self purchaseSubscriptionsWithMonths:6];
            
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

- (int)daysRemainingOnSubscription{
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults]objectForKey:kSubscriptionExpirationDateKey];
    
    NSTimeInterval timeInt = [expirationDate timeIntervalSinceDate:[NSDate date]];
    
    int days = timeInt / 60 / 60 / 24;
    
    if (days > 0) {
        return days;
    }else{
        return 0;
    }
}

- (NSString *)getExpirationDateString{
    if ([self daysRemainingOnSubscription] > 0) {
        NSDate *today = [[NSUserDefaults standardUserDefaults]objectForKey:kSubscriptionExpirationDateKey];
        NSDateFormatter *dateFormat = [NSDateFormatter new];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        return [NSString stringWithFormat:@"Subscribed! Expires: %@ (%i Days)", [dateFormat stringFromDate:today], [self daysRemainingOnSubscription]];
    }else{
        return @"Not Subscribed";
    }
    
}

- (NSDate *)getExpirationDateForMonths:(int)months{
    NSDate *originDate = nil;
    
    if ([self daysRemainingOnSubscription] > 0) {
        originDate = [[NSUserDefaults standardUserDefaults]objectForKey:kSubscriptionExpirationDateKey];
    }else{
        originDate = [NSDate date];
    }
    
    NSDateComponents *dateComp = [NSDateComponents new];
    [dateComp setMonth:months];
    [dateComp setDay:1];
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                         toDate:originDate
                                                        options:0];
}

- (void)purchaseSubscriptionsWithMonths:(int)months{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject *object, NSError *error){
        
        NSDate *serverDate = [[object objectForKey:kSubscriptionExpirationDateKey]lastObject];
        NSDate *localDate = [[NSUserDefaults standardUserDefaults]objectForKey:kSubscriptionExpirationDateKey];
        
        if ([serverDate compare:localDate] == NSOrderedDescending) {
            [[NSUserDefaults standardUserDefaults] setObject:serverDate forKey:kSubscriptionExpirationDateKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        NSDate *expirationDate = [self getExpirationDateForMonths:months];
        
        [object addObject:expirationDate forKey:kSubscriptionExpirationDateKey];
        [object saveInBackground];
        
        [[NSUserDefaults standardUserDefaults]setObject:expirationDate forKey:kSubscriptionExpirationDateKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSLog(@"Subscription Complete");
    }];
}



@end
