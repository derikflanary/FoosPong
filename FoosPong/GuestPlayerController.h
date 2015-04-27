//
//  GuestPlayerController.h
//  FoosPong
//
//  Created by Derik Flanary on 4/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuestPlayerController : NSObject

+ (GuestPlayerController *)sharedInstance;
- (void)createGuestPlayerFromUser:(PFUser *)guest callback:(void (^)(PFObject *))callback;

@end
