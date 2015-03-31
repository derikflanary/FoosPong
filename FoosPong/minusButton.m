//
//  minusButton.m
//  FoosPong
//
//  Created by Derik Flanary on 3/31/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "MinusButton.h"

@implementation MinusButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor darkColor];
    }
    else {
        self.backgroundColor = [UIColor darkColorTransparent];
    }
}



@end
