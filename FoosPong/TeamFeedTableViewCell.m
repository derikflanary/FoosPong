//
//  TeamFeedTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 3/30/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamFeedTableViewCell.h"

@implementation TeamFeedTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TeamFeedCell"];
    
    self.playerOneLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 11, 150, 21)];
    self.playerOneLabel.font = [UIFont fontWithName:[NSString boldFont] size:18];
    self.playerOneLabel.textColor = [UIColor darkColor];
    self.playerOneLabel.textAlignment = NSTextAlignmentCenter;
    
    self.playerTwoLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 11, 150, 21)];
    self.playerTwoLabel.font = [UIFont fontWithName:[NSString boldFont] size:18];
    self.playerTwoLabel.textColor = [UIColor darkColor];
    self.playerTwoLabel.textAlignment = NSTextAlignmentCenter;
    
    self.playerOneScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 40, 150, 31)];
    self.playerOneScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:26];
    self.playerOneScoreLabel.textColor = [UIColor marigoldBrown];
    self.playerOneScoreLabel.textAlignment = NSTextAlignmentCenter;
    
    self.playerTwoScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 40, 150, 31)];
    self.playerTwoScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:26];
    self.playerTwoScoreLabel.textColor = [UIColor marigoldBrown];
    self.playerTwoScoreLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 40, 100, 21)];
    self.dateLabel.font = [UIFont fontWithName:[NSString mainFont] size:10];
    self.dateLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    //self.dateLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.playerOneLabel];
    [self.contentView addSubview:self.playerTwoLabel];
    [self.contentView addSubview:self.playerOneScoreLabel];
    [self.contentView addSubview:self.playerTwoScoreLabel];
    [self.contentView addSubview:self.dateLabel];
    
    self.playerOneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerTwoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerOneScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.playerTwoScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_playerOneLabel, _playerOneScoreLabel, _playerTwoLabel, _playerTwoScoreLabel, _dateLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==11)-[_playerOneLabel(>=160)]-[_playerTwoLabel(==_playerOneLabel)]-(==11)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==11)-[_playerOneScoreLabel(>=50)]-[_playerTwoScoreLabel(==_playerOneScoreLabel)]-(==11)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==40)-[_dateLabel(==21)]-(==21)-|" options:0 metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==100)-[_dateLabel(>=80)]-(==100)-|" options:0 metrics:nil views:viewsDictionary]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==11)-[_playerOneLabel(==21)]-[_playerOneScoreLabel(==31)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==11)-[_playerTwoLabel(==21)]-[_playerTwoScoreLabel(==31)]-(>=0)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];


    
    
    self.backgroundColor = [UIColor transparentCellWhite];

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor darkColorTransparent];
    self.playerOneLabel.highlightedTextColor = [UIColor mainWhite];
    self.playerTwoLabel.highlightedTextColor = [UIColor mainWhite];
    
    [self setSelectedBackgroundView:bgColorView];
    
    
    
    return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
