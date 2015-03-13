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
- (void)findGroupsForUser:(PFUser *)user callback:(void (^)(NSArray *))callback;
- (void)retrieveCurrentGroupWithCallback:(void (^)(PFObject *))callback;
- (void)setCurrentGroup:(PFObject *)group;

-(void)testcallback:(void (^)(PFObject *))callback;
@end
