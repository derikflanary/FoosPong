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
