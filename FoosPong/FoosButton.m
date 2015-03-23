//
//  FoosButton.m
//  FoosPong
//
//  Created by Derik Flanary on 3/23/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "FoosButton.h"

@implementation FoosButton

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor mainColorTransparent];
    }
    else {
        self.backgroundColor = [UIColor darkColor];
    }
}

@end
