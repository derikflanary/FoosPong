//
//  TeamMemberCustomTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 3/30/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamMemberCustomTableViewCell.h"

@implementation TeamMemberCustomTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TeamMemberCell"];
    
    self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 40, 40)];
    self.profileImageView.layer.cornerRadius = 20.0f;
    self.profileImageView.clipsToBounds = YES;
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.profileImageView.frame) + 8, 11, 220, 21)];
    self.nameLabel.font = [UIFont fontWithName:[NSString boldFont] size:18];
    self.nameLabel.textColor = [UIColor darkColor];
    
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 32, 100, 21)];
    self.scoreLabel.textColor = [UIColor marigoldBrown];
    self.scoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:13];
    
    self.doublesRankLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 32, 100, 21)];
    self.doublesRankLabel.textColor = [UIColor marigoldBrown];
    self.doublesRankLabel.font = [UIFont fontWithName:[NSString mainFont] size:13];
    self.doublesRankLabel.textAlignment = NSTextAlignmentRight;
    
    
    self.adminLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 11, 71, 21)];
    self.adminLabel.font = [UIFont fontWithName:[NSString mainFont] size:10];
    self.adminLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    self.adminLabel.textAlignment = NSTextAlignmentRight;
    
    self.fullNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 53, 150, 21)];
    self.fullNameLabel.font = [UIFont fontWithName:[NSString mainFont] size:10];
    self.fullNameLabel.textColor = [UIColor lunarGreen];
    
    
    self.backgroundColor = [UIColor transparentCellWhite];
    
    [self.contentView addSubview:self.profileImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.adminLabel];
    [self.contentView addSubview:self.fullNameLabel];
    [self.contentView addSubview:self.doublesRankLabel];
    
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.adminLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.doublesRankLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_profileImageView, _nameLabel, _adminLabel, _scoreLabel, _fullNameLabel, _doublesRankLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==68)-[_nameLabel(>=180)]-[_adminLabel(>=40)]-(==21)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==68)-[_scoreLabel(>=100)]-[_doublesRankLabel(>=100)]-(==21)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==68)-[_fullNameLabel(>=100)]-(==21)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==11)-[_nameLabel(==21)]-(==0)-[_scoreLabel(==21)]-(==0)-[_fullNameLabel(==21)]-(<=8)-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDictionary]];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor darkColorTransparent];
    self.nameLabel.highlightedTextColor = [UIColor mainWhite];
    
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
