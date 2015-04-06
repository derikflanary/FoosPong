//
//  TeamMemberCustomTableViewCell.h
//  FoosPong
//
//  Created by Derik Flanary on 3/30/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMemberCustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *profileImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UILabel *adminLabel;

@property (nonatomic, strong) UILabel *fullNameLabel;

@property (nonatomic, strong) UILabel *lastDatePlayedLabel;

@property (nonatomic, strong) UILabel *recordLabel;

@property (nonatomic, strong) UILabel *doublesRankLabel;

@end
