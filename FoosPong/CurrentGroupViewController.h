//
//  CurrentGroupViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface CurrentGroupViewController : MasterViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *groupMembers;

- (void)checkForGroup;

@end
