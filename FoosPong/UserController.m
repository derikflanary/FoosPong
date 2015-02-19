//
//  UserController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "UserController.h"


@interface UserController()
@property (nonatomic, strong)NSArray *users;
@property (nonatomic, strong)NSArray *usersWithoutCurrentUser;
@end

@implementation UserController

+ (UserController *)sharedInstance {
    static UserController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserController alloc] init];
        [sharedInstance updateUsers];
        [sharedInstance findCurrentUser];
        
    });
    return sharedInstance;
}

-(void)findCurrentUser{
    
    PFUser *currentUser = [PFUser currentUser];
    self.theCurrentUser = currentUser;
}

-(void)addUserwithDictionary:(NSDictionary*)dictionary{
    
    PFUser *user = [PFUser user];
    user.username = dictionary[@"username"];
    user.password = dictionary[@"password"];
    user[@"firstName"] = dictionary[@"firstName"];
    user[@"lastName"] = dictionary[@"lastName"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }else{
            NSLog(@"%@", error);
        }
    }];
    
//    [PFUser logInWithUsernameInBackground:dictionary[@"username"] password:dictionary[@"password"]
//                                    block:^(PFUser *user, NSError *error) {
//                                        if (user) {
//                                            
//                                        } else {
//                                            NSLog(@"%@", error);// The login failed. Check error to see why.
//                                        }
//                                    }];
}

-(void)updateUsers{
    
    PFQuery *query = [PFUser query];
    //[query whereKey:@"username" notEqualTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.users = objects;
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
    
    PFQuery *nextQuery = [PFUser query];
    [nextQuery whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    [nextQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.usersWithoutCurrentUser = objects;
            } else {

            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(NSArray*)usersWithoutCurrentUser:(PFUser*)currentUser{
PFQuery *query = [PFUser query];
[query whereKey:@"username" notEqualTo:currentUser.username];
[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
        
        for (PFUser *object in objects) {
            NSLog(@"%@", object.username);
            
        }
        self.usersWithoutCurrentUser = objects;
        
        
        //[self.players addObjectsFromArray:self.users];
        
    } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}];
    return self.usersWithoutCurrentUser;
}

-(void)removeUser:(PFUser *)user{
    
    
}

-(void)saveUsers{
    
}


@end
