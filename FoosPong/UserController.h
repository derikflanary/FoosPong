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
    
- (void)addUserwithDictionary:(NSDictionary*)dictionary Callback:(void (^)(BOOL *, NSError * error))callback;

- (void)addGuestUserWithArray:(NSArray*)users;

- (void)removeUser:(PFUser *)user;

- (void)updateUsers;

- (NSArray*)usersWithoutCurrentUser:(PFUser*)currentUser;

- (void)loginUser:(NSDictionary*)dictionary callback:(void (^)(PFUser *))callback;

- (void)saveProfilePhoto:(UIImage*)image;

- (void)retrieveProfileImageForUser:(PFUser *)user withCallback:(void (^)(UIImage *))callback;


@property (nonatomic, strong, readonly)NSArray *users;
@property (nonatomic, strong, readonly)NSArray *usersWithoutCurrentUser;
@property (nonatomic, strong)PFUser *theCurrentUser;



@end
