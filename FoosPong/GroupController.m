//
//  GroupController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GroupController.h"
#import "UserController.h"

static NSString * const currentGroupKey = @"currentGroup";
static NSString * const membersKey = @"members";
static NSString * const currentGameKey = @"currentGame";
static NSString * const nameKey = @"name";
static NSString * const organizationKey = @"organization";
static NSString * const groupKey = @"Group";
static NSString * const adminKey = @"admin";
static NSString * const passwordKey = @"password";


@implementation GroupController


+ (GroupController *)sharedInstance {
    static GroupController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GroupController alloc] init];

        
    });
    return sharedInstance;
}

- (void)addGroupforAdmin:(Group *)newGroup callback:(void (^)(BOOL *))callback{
    
    if (newGroup) {
        PFObject *group = [PFObject objectWithClassName:@"Group"];
        group[@"admin"] = newGroup.admin;
        group[@"name"] = newGroup.name;
        group[@"organization"] = newGroup.organization;
        group[@"password"] = newGroup.password;
        group[@"members"] = @[newGroup.admin];
        PFACL *groupACL = [PFACL ACLWithUser:newGroup.admin];
                [groupACL setPublicReadAccess:YES];
        [groupACL setPublicWriteAccess:YES];
        group.ACL = groupACL;
        [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                callback(&succeeded);
            }else{
                NSLog(@"%@", error);
            }
        }];
        
    }else{
        return;
    }
}

- (BOOL)isUserAdmin{
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *currentGroup = currentUser[currentGroupKey];
    PFUser *admin = currentGroup[adminKey];
    
    if (admin == currentUser) {
        return YES;
    }else{
        return NO;
    }
}

- (void)addUser:(PFUser *)user toGroup:(PFObject *)group{
    
    [group addUniqueObject:user forKey:membersKey];
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            [self setCurrentGroup:group];
        }else{
            NSLog(@"%@", error);
        }
    }];
}

- (void)removeUserFromGroup:(PFUser *)user{
    
}

- (void)findGroupsForUser:(PFUser *)user callback:(void (^)(NSArray *, NSError *error))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:membersKey equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.groups = objects;
            callback(objects, nil);
            
        } else {
            callback(nil, error);
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }

    }];
}

- (void)setCurrentGroup:(PFObject *)group{
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[currentGroupKey] = group;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Current Group Saved");
        }else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)retrieveCurrentGroupWithCallback:(void (^)(PFObject *, NSError *error))callback{
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *group = currentUser[currentGroupKey];
    [group fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if (!object) {
                callback (nil, nil);
            }else{
                callback(object, nil);
            }
        }else{
            callback(nil, error);
        }
    }];
    
}

- (void)findGroupsByName:(NSString*)name withCallback:(void (^)(NSArray*))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"name" containsString:name];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Group"];
    [query2 whereKey:@"organization" containsString:name];
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query, query2]];
    [theQuery orderByAscending:@"name"];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            callback(objects);
        }else{
            NSLog(@"%@", error);
        }
    }];

}

- (NSArray*)membersForCurrentGroup:(PFObject *)currentGroup{
    
        NSArray *members = currentGroup[membersKey];
        return members;

}

- (void)notMembersOfCurrentGroupCallback:(void (^)(NSArray*))callback{
    PFUser *currentUser = [PFUser currentUser];
    NSArray *members = [self membersForCurrentGroup:currentUser[currentGroupKey]];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notContainedIn:[members valueForKey:@"objectId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            callback(objects);
        }else{
            NSLog(@"%@", error);
        }
    }];
    
    NSMutableArray *users = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
    for (PFUser *member in members) {
        if ([users containsObject:member]) {
            [users removeObject:member];
        }
        callback(users);
    }
}


    




@end
