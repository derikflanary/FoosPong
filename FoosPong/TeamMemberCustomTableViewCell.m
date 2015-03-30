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
    
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 32, 220, 21)];
    self.scoreLabel.textColor = [UIColor marigoldBrown];
    self.scoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:16];
    
    self.adminLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 53, 71, 21)];
    self.adminLabel.font = [UIFont fontWithName:[NSString mainFont] size:10];
    self.adminLabel.textColor = [UIColor colorWithWhite:.4 alpha:1];
    self.adminLabel.textAlignment = NSTextAlignmentRight;
    
    self.fullNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 53, 150, 21)];
    self.fullNameLabel.font = [UIFont fontWithName:[NSString mainFont] size:12];
    self.fullNameLabel.textColor = [UIColor lunarGreen];
    
    
    self.backgroundColor = [UIColor transparentCellWhite];
    
    [self.contentView addSubview:self.profileImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.adminLabel];
    [self.contentView addSubview:self.fullNameLabel];
    
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
