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

+ (UIColor *)mainColor{
    UIColor* mainColor = [UIColor colorWithRed:122.0/255 green:207.0/255 blue:99.0/255 alpha:1.0f];
    return mainColor;
}

+ (UIColor *)darkColor{
    UIColor* darkColor = [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)mainColorTransparent{
    UIColor* mainColor = [UIColor colorWithRed:122.0/255 green:207.0/255 blue:99.0/255 alpha:.8f];
    return mainColor;
}

+ (UIColor *)transparentWhite{
    UIColor* color = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:.8];
    return color;
}

+ (UIColor *)mainWhite{
    UIColor* color = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1];
    return color;
}

+ (UIColor *)mainBlack{
    UIColor* color = [UIColor colorWithRed:.16 green:.17 blue:.2 alpha:1];
    return color;
}

+ (UIColor *)transparentCellWhite{
    UIColor* color = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:.5];
    return color;
}




@end
