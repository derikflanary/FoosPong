//
//  TeamFeedTableViewCell.h
//  FoosPong
//
//  Created by Derik Flanary on 3/30/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamFeedTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * playerOneLabel;

@property (nonatomic, strong) UILabel * playerTwoLabel;

@property (nonatomic, strong) UILabel * playerOneScoreLabel;

@property (nonatomic, strong) UILabel * playerTwoScoreLabel;

@property (nonatomic, strong) UILabel * vsLabel;

@property (nonatomic, strong) UILabel * dateLabel;

@end
