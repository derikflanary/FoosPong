//
//  HistoryTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 3/21/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HistoryGameCell"];
    self.textLabel.font = [UIFont fontWithName:@"Thonburi-Light" size:18];
    self.detailTextLabel.font = [UIFont boldSystemFontOfSize:11];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor mainColorTransparent];
    self.textLabel.highlightedTextColor = [UIColor mainWhite];
    [self setSelectedBackgroundView:bgColorView];

    
    
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
