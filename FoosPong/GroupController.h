//
//  GroupController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"

@interface GroupController : NSObject

@property (nonatomic, strong) NSArray *groups;

+ (GroupController *)sharedInstance;
- (void)addGroupforAdmin:(Group *)newGroup callback:(void (^)(BOOL *))callback;
- (void)findGroupsForUser:(PFUser *)user callback:(void (^)(NSArray *, NSError *error))callback;
- (void)retrieveCurrentGroupWithCallback:(void (^)(PFObject * group, NSError *error))callback;
- (void)setCurrentGroup:(PFObject *)group;
- (void)findGroupsByName:(NSString*)name withCallback:(void (^)(NSArray *foundGroups))callback;
- (void)addUser:(PFUser *)user toGroup:(PFObject *)group;
- (void)fetchAdminForGroup:(PFObject*)group callback:(void (^)(PFObject *))callback;
- (NSArray*)membersForCurrentGroup:(PFObject *)currentGroup;
- (void)notMembersOfCurrentGroupsearchString:(NSString *)searchString callback:(void (^)(NSArray*))callback;
- (void)fetchMembersOfGroup:(PFObject *)group Callback:(void (^)(NSArray *))callback;
- (void)removeUserFromGroup:(PFUser *)user callback:(void (^)(BOOL *))callback;
- (void)deleteGroupCallback:(void (^)(BOOL *))callback;

@end
