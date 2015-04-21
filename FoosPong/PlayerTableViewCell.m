//
//  PlayerTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 3/21/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "PlayerTableViewCell.h"

@implementation PlayerTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PlayerGameCell"];
    
    self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 40, 40)];
    self.profileImageView.layer.cornerRadius = 20.0f;
    self.profileImageView.clipsToBounds = YES;
    //self.profileImageView.image = [UIImage imageNamed:@"74"];
    self.profileImageView.backgroundColor = [UIColor darkColor];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 11, 220, 21)];
    self.nameLabel.font = [UIFont fontWithName:[NSString boldFont] size:18];
    self.nameLabel.textColor = [UIColor darkColor];
    
    self.adminLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 32, 71, 21)];
    self.adminLabel.font = [UIFont fontWithName:[NSString mainFont] size:10];
    self.adminLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    self.adminLabel.textAlignment = NSTextAlignmentRight;
    
    self.fullNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 32, 220, 21)];
    self.fullNameLabel.font = [UIFont fontWithName:[NSString mainFont] size:12];
    self.fullNameLabel.textColor = [UIColor marigoldBrown];
    
    self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(183, 11, 120, 21)];
    self.rankLabel.font = [UIFont fontWithName:[NSString mainFont] size:16];
    self.rankLabel.textColor = [UIColor lunarGreen];
    self.rankLabel.textAlignment = NSTextAlignmentRight;
    
    self.positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(183, 32, 120, 21)];
    self.positionLabel.font = [UIFont fontWithName:[NSString mainFont] size:14];
    self.positionLabel.textColor = [UIColor darkColorTransparent];
    self.positionLabel.textAlignment = NSTextAlignmentRight;
    
    self.backgroundColor = [UIColor transparentCellWhite];
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor darkColorTransparent];
    self.nameLabel.highlightedTextColor = [UIColor mainWhite];
    
    [self setSelectedBackgroundView:bgColorView];
    
    
    [self.contentView addSubview:self.profileImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.adminLabel];
    [self.contentView addSubview:self.fullNameLabel];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.positionLabel];
    
    
//    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.rankLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.adminLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.positionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.fullNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_profileImageView, _nameLabel, _rankLabel, _adminLabel, _positionLabel, _fullNameLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==68)-[_nameLabel(>=120)]-[_rankLabel(>=80)]-(==21)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==68)-[_fullNameLabel(>=100)]-[_positionLabel(>=100)]-[_adminLabel(>=50)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==11)-[_nameLabel(==21)]-(==0)-[_fullNameLabel]-(<=8)-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDictionary]];
    
    
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
