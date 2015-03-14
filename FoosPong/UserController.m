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
        
    });
    return sharedInstance;
}


- (void)addGuestUser{
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            NSLog(@"Anonymous login failed.");
        } else {
            NSLog(@"Anonymous user logged in.");
        }
    }];
}

- (void)addUserwithDictionary:(NSDictionary*)dictionary{
    
    PFUser *user = [PFUser user];
    user.username = dictionary[@"username"];
    user.password = dictionary[@"password"];
    user[@"firstName"] = dictionary[@"firstName"];
    user[@"lastName"] = dictionary[@"lastName"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self updateUsers];
        }else{
            NSLog(@"%@", error);
        }
    }];
    
}

- (void)loginUser:(NSDictionary*)dictionary callback:(void (^)(PFUser *))callback{
    
        [PFUser logInWithUsernameInBackground:dictionary[@"username"] password:dictionary[@"password"]
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                [self updateUsers];
                                                callback(user);
                                            } else {
                                                NSLog(@"%@", error);
                                                callback(nil);
                                                // The login failed. Check error to see why.
                                            }
                                        }];
}

- (void)updateUsers{
    if ([PFUser currentUser]) {
        PFQuery *query = [PFUser query];
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
}


- (NSArray*)usersWithoutCurrentUser:(PFUser*)currentUser{
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

- (void)saveProfilePhoto:(UIImage*)image{
    
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"profileImage.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                PFUser *user = [PFUser currentUser];
               
                user[@"profileImage"] = imageFile;
                [user saveInBackground];
            }
        } else {
            // Handle error
        }        
    }];
    PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
    userPhoto[@"imageName"] = @"My trip to Hawaii!";
    userPhoto[@"imageFile"] = imageFile;
    [userPhoto saveInBackground];
}

- (void)retrieveProfileImageWithCallback:(void (^)(UIImage *))callback{
    PFUser *user = [PFUser currentUser];
    PFFile *userImageFile = user[@"profileImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        }else{
            callback(nil);
        }
    }];
    

}

- (void)removeUser:(PFUser *)user{
    
    
}

- (void)saveUsers{
    
}


@end
