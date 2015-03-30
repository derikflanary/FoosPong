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
    UIColor* darkColor = [UIColor colorWithRed:.22 green:.29 blue:.24 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)marigoldBrown{
    UIColor* darkColor = [UIColor colorWithRed:.73 green:.53 blue:.25 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)golderBrown{
    UIColor* darkColor = [UIColor colorWithRed:.62 green:.39 blue:.05 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)vanilla{
    UIColor* darkColor = [UIColor colorWithRed:.81 green:.73 blue:.6 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)indianYellow{
    UIColor* darkColor = [UIColor colorWithRed:.87 green:.65 blue:.35 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)mint{
    UIColor* darkColor = [UIColor colorWithRed:.31 green:.69 blue:.55 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)lunarGreen{
    UIColor* darkColor = [UIColor colorWithRed:.24 green:.59 blue:.45 alpha:1.0f];
    return darkColor;
}

+ (UIColor *)mainWhite{
    UIColor* color = [UIColor colorWithRed:.88 green:.88 blue:.88 alpha:1];
    return color;
}


+ (UIColor *)darkColorTransparent{
    UIColor* mainColor = [UIColor colorWithRed:.22 green:.29 blue:.24 alpha:.7f];
    return mainColor;
}

+ (UIColor *)transparentWhite{
    UIColor* color = [UIColor colorWithRed:.88 green:.88 blue:.88 alpha:.8];
    return color;
}


+ (UIColor *)transparentCellWhite{
    UIColor* color = [UIColor colorWithRed:.88 green:.88 blue:.88 alpha:.5];
    return color;
}




@end
