//
//  SettingsTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 3/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SettingsGameCell"];
    self.textLabel.font = [UIFont fontWithName:@"Thonburi-Light" size:18];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];


    
    
    
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
