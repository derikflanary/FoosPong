//
//  SubscriptionTableViewCell.m
//  FoosPong
//
//  Created by Derik Flanary on 4/30/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SubscriptionTableViewCell.h"

@implementation SubscriptionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    self.label = [[UILabel alloc]initWithFrame:self.contentView.frame];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:[NSString mainFont] size:21];
    self.label.numberOfLines = 0;
    self.label.textColor = [UIColor mainWhite];
    [self.contentView addSubview:self.label];
    
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_label);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_label(>=180)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_label(>=51)]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
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
