//
//  SettingsTableViewCell.h
//  FoosPong
//
//  Created by Derik Flanary on 3/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsSegmentedTableViewCell : UITableViewCell

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end
