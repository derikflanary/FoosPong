//
//  MembersTableViewDataSource.h
//  FoosPong
//
//  Created by Derik Flanary on 3/20/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MembersTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *groupMembers;
@property (nonatomic, strong) PFObject *group;

- (void)registerTableView:(UITableView *)tableView;

@end
