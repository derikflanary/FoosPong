//
//  StatisticsCustomTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 4/4/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "StatisticsCustomTableViewCell.h"

@implementation StatisticsCustomTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StatisticsGameCell"];
    self.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:20];
    self.textLabel.textColor = [UIColor whiteColor];
    self.detailTextLabel.textColor = [UIColor vanilla];
    
    self.backgroundColor = [UIColor clearColor];
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
