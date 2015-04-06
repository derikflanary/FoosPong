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
    //self.dateLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.playerOneLabel];
    [self.contentView addSubview:self.playerTwoLabel];
    [self.contentView addSubview:self.playerOneScoreLabel];
    [self.contentView addSubview:self.playerTwoScoreLabel];
    [self.contentView addSubview:self.dateLabel];
    
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
