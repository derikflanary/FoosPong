//
//  GroupController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GroupController.h"
#import "UserController.h"
#import "RankingController.h"

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
                [self setCurrentGroup:group callback:^(BOOL *success) {
                    newGroup.admin[@"hasCreatedTeam"] =[NSNumber numberWithBool:YES];
                    [newGroup.admin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                        if (!error) {
                            [[RankingController sharedInstance]createRankingforUser:[PFUser currentUser] forGroup:group withCallback:^(BOOL *itSucceeded) {
                                
                                callback(itSucceeded);
                                
                            }];
                        }
                    }];
                    
                }];

                
            }else{
                NSLog(@"%@", error);
            }
        }];
        
    }else{
        return;
    }
}

- (void)fetchAdminForGroup:(PFObject*)group callback:(void (^)(PFObject *))callback{
    
    
    PFUser *admin = group[adminKey];
    [admin fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        callback(object);
    }];
}


- (void)addUser:(PFUser *)user toGroup:(PFObject *)group callback:(void (^)(BOOL *))callback{
    
    [group addUniqueObject:user forKey:membersKey];
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            [self setCurrentGroup:group callback:^(BOOL *succeeded) {
                
                [[RankingController sharedInstance]createRankingforUser:user forGroup:group withCallback:^(BOOL *itSucceeded) {
                    callback(itSucceeded);
                }];

            }];
        }else{
            NSLog(@"%@", error);
        }
    }];
}

- (void)removeUserFromGroup:(PFUser *)user callback:(void (^)(BOOL *))callback{
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *group = currentUser[currentGroupKey];
    [group removeObject:user forKey:membersKey];
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
            callback(&succeeded);
            NSLog(@"Player removed");
        }else{
            NSLog(@"%@", error);
        }
    }];
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

- (void)setCurrentGroup:(PFObject *)group callback:(void (^)(BOOL *))callback{
    
     PFUser *currentUser = [PFUser currentUser];
    
    if (!group) {
        [self findGroupsForUser:currentUser callback:^(NSArray *groups, NSError *error) {
            
            if ([groups count] == 0) {
                [currentUser removeObjectForKey:currentGroupKey];
                
            }else{
                currentUser[currentGroupKey] = [groups firstObject];
            }
            
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Current Group Set");
                    callback (&succeeded);
                }else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }];
        
    }else{
        currentUser[currentGroupKey] = group;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"Current Group Saved");
                callback (&succeeded);
            }else{
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
   
    
        
}

- (void)retrieveCurrentGroupWithCallback:(void (^)(PFObject *, NSError *error))callback{
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *group = currentUser[currentGroupKey];
    [group fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
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

- (NSArray*)membersForCurrentGroup:(PFObject *)currentGroup{
    
    NSArray *members = currentGroup[membersKey];
    return members;
    
}

- (void)fetchMembersOfGroup:(PFObject *)group Callback:(void (^)(NSArray *))callback{
    
    NSArray *members = group[membersKey];
    //NSMutableArray *fetchedMembers = [NSMutableArray array];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" containedIn:[members valueForKey:@"objectId"]];
//    [query includeKey:@"ranking"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            
            
            
            callback(objects);
//            for (PFUser *user in objects) {
//                PFObject *ranking = user[@"ranking"];
//                PFObject *groupForRanking = ranking[@"group"];
//                if (groupForRanking.objectId != group.objectId ) {
//                    //go get the ranking and set it's pointer to this user
//                    [[RankingController sharedInstance]goSetCorrectRankingForUser:user andGroup:group withCallback:^(BOOL *succeeded) {
//                        
//                        callback(objects);
//                    }];
//                }
//            }
            
            
            
            
        }else{
            NSLog(@"%@", error);
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


- (void)notMembersOfCurrentGroupsearchString:(NSString *)searchString callback:(void (^)(NSArray*))callback {
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *members = [self membersForCurrentGroup:currentUser[currentGroupKey]];
    
    PFQuery *query2 = [PFUser query];
    [query2 whereKey:@"firstName" containsString:searchString];
    
    PFQuery *query3 = [PFUser query];
    [query3 whereKey:@"lastName" containsString:searchString];
    
    PFQuery *query4 = [PFUser query];
    [query4 whereKey:@"username" containsString:searchString];
    
    PFQuery *theQuery = [PFQuery orQueryWithSubqueries:@[query2, query3, query4]];
    [theQuery whereKey:@"objectId" notContainedIn:[members valueForKey:@"objectId"]];
    [theQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            callback(objects);
        }else{
            NSLog(@"%@", error);
        }
    }];
}

- (void)deleteGroupCallback:(void (^)(BOOL *))callback{
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *group = currentUser[currentGroupKey];
    [group deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [currentUser removeObjectForKey:currentGroupKey];
        callback(&succeeded);
        
    }];
}

- (void)saveGroupMembers:(PFObject *)group andMembers:(NSArray *)members{
    
    group[membersKey] = members;
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    }];
    
}
    




@end
