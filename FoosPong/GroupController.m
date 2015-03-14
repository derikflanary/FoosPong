//
//  GroupController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GroupController.h"

static NSString * const currentGroupKey = @"currentGroup";

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
        PFACL *groupACL = [PFACL ACLWithUser:newGroup.admin];
        [groupACL setWriteAccess:YES forUser:newGroup.admin];
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

- (void)addUserToGroup:(PFUser *)user withAdmin:(PFUser *)admin{
    
}

- (void)removeUserFromGroup:(PFUser *)user{
    
}

- (void)findGroupsForUser:(PFUser *)user callback:(void (^)(NSArray *, NSError *error))callback{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"admin" equalTo:user];
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
            callback(object, nil);
        }else{
            callback(nil, error);
        }
    }];
  
}





@end
