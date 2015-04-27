//
//  GuestPlayerController.m
//  FoosPong
//
//  Created by Derik Flanary on 4/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GuestPlayerController.h"

@implementation GuestPlayerController

+ (GuestPlayerController *)sharedInstance {
    static GuestPlayerController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GuestPlayerController alloc] init];
        
    });
    return sharedInstance;
}


- (void)createGuestPlayerFromUser:(PFUser *)guest callback:(void (^)(PFObject *))callback{
    
    PFObject *guestPlayer = [PFObject objectWithClassName:@"GuestPlayer"];
    guestPlayer[@"username"] = guest.username;
    [guestPlayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if (!error) {
            callback(guestPlayer);
        }
    }];
    
}

@end
