//
//  UserController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserController : NSObject

+ (UserController *)sharedInstance;
    
-(void)addUser;

-(NSArray*)users;

-(void)removeUser:(PFUser *)user;

-(NSArray*)usersWithoutCurrentUser:(PFUser*)currentUser;
    
@property (nonatomic, strong, readonly)NSArray *users;
@property (nonatomic, strong, readonly)NSArray *usersWithoutCurrentUser;
@property (nonatomic, strong)PFUser *theCurrentUser;



@end
