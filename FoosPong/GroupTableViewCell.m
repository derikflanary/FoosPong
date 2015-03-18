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
    
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewGameCell"];
    self.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:26];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];
    
    //    self.layer.cornerRadius = 10;
    //    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor darkColor];
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
