//
//  GroupTableViewCell.h
//  FoosPong
//
//  Created by Derik Flanary on 3/17/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *teamNameLabel;

@property (nonatomic, strong) UILabel *currentGroupLabel;

@property (nonatomic, strong) UILabel *organizationLabel;

@property (nonatomic, strong) UILabel *numberOfMembersLabel;


@end
