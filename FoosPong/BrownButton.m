//
//  BrownButton.m
//  FoosPong
//
//  Created by Derik Flanary on 4/22/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "BrownButton.h"

@implementation BrownButton

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor transparentMarigoldBrown];
    }
    else {
        self.backgroundColor = [UIColor marigoldBrown];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
