//
//  PlayerTableViewCell.h
//  FoosPong
//
//  Created by Derik Flanary on 3/21/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *adminLabel;

@property (nonatomic, strong) UIImageView *profileImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *fullNameLabel;

@property (nonatomic, strong) UILabel *memberSinceLabel;

@end
