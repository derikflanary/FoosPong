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
    
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PlayerGameCell"];
    self.textLabel.font = [UIFont fontWithName:@"Thonburi-Light" size:22];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:12];
    
    self.adminLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 0, 80, 40)];
    self.adminLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview: self.adminLabel];
    
    //    self.layer.cornerRadius = 10;
    //    self.clipsToBounds = YES;
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
