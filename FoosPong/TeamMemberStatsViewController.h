//
//  GroupStatsViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 3/20/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMemberStatsViewController : UIViewController

@property (nonatomic, strong) PFObject *ranking;
@property (nonatomic, strong) PFUser *user;

@end
