//
//  UIColor+ExtraColorTools.m
//  FoosPong
//
//  Created by Derik Flanary on 2/21/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "UIColor+ExtraColorTools.h"

@implementation UIColor (ExtraColorTools)

+ (UIColor *)randomColor{
    
    CGFloat redNumber = ((CGFloat)arc4random() / RAND_MAX);
    CGFloat greenNumber =  ((CGFloat)arc4random() / RAND_MAX);
    CGFloat blueNumber =  ((CGFloat)arc4random() / RAND_MAX);
    NSLog(@"%f, %f, %f", redNumber, greenNumber, blueNumber);
    
    
    UIColor *color = [[UIColor alloc] initWithRed:redNumber green:greenNumber blue:blueNumber alpha:1];
    
    return color;
}

@end