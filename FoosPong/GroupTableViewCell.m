//
//  GroupTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 3/17/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GroupTableViewCell.h"

@implementation GroupTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GroupCell"];
    
    self.teamNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 11, self.frame.size.width - 22, 21)];
    self.teamNameLabel.font = [UIFont fontWithName:[NSString boldFont] size:22];
    self.teamNameLabel.textColor = [UIColor darkColor];
    
    self.organizationLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 30, self.teamNameLabel.frame.size.width, 21)];
    self.organizationLabel.font = [UIFont fontWithName:[NSString mainFont] size:14];
    self.organizationLabel.textColor = [UIColor marigoldBrown];
    
    self.currentGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 30, 90, 21)];
    self.currentGroupLabel.font = [UIFont fontWithName:[NSString mainFont] size:12];
    self.currentGroupLabel.textColor = [UIColor mainWhite];
    self.currentGroupLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.teamNameLabel];
    [self.contentView addSubview:self.organizationLabel];
    [self.contentView addSubview:self.currentGroupLabel];
    
    
    
    self.backgroundColor = [UIColor transparentCellWhite];
        
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
