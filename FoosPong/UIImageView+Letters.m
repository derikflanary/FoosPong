//
//  UIImageView+Letters.m
//
//  Created by Tom Bachant on 6/17/14.
//  Copyright (c) 2014 Tom Bachant. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIImageView+Letters.h"

@implementation UIImageView (Letters)

- (void)setImageWithString:(NSString *)string {
    [self setImageWithString:string color:nil];
}

- (void)setImageWithString:(NSString *)string color:(UIColor *)color {
    NSMutableString *displayString = [NSMutableString stringWithString:@""];
    
    NSMutableArray *words = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    
    //
    // Get first letter of the first and last word
    //
    if ([words count]) {
        NSString *firstWord = [words firstObject];
        if ([firstWord length] != 0) {
            [displayString appendString:[firstWord substringToIndex:1]];
        }
        
        if ([words count] >= 2) {
            NSString *lastWord = [words lastObject];
            
            while([lastWord length] == 0 && [words count] >= 2) {
                [words removeLastObject];
                lastWord = [words lastObject];
            }
            
            if([words count] > 1) {
                [displayString appendString:[lastWord substringToIndex:1]];
            }
        }
    }
    
    UIColor *backgroundColor = color ? color : [self randomColor];
    
    self.image = [self imageSnapshotFromText:[displayString uppercaseString] backgroundColor:backgroundColor];
}

#pragma mark - Helpers

- (UIFont *)fontForText {
    return [UIFont systemFontOfSize:CGRectGetWidth(self.bounds) * 0.48];
}

- (UIColor *)randomColor {
    
    float red = 0.0;
    while (red < 0.1 || red > 0.84) {
        red = drand48();
    }
    
    float green = 0.0;
    while (green < 0.1 || green > 0.84) {
        green = drand48();
    }
    
    float blue = 0.0;
    while (blue < 0.1 || blue > 0.84) {
        blue = drand48();
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (UIImage *)imageSnapshotFromText:(NSString *)text backgroundColor:(UIColor *)color {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize size = self.bounds.size;
    if (self.contentMode == UIViewContentModeScaleToFill ||
        self.contentMode == UIViewContentModeScaleAspectFill ||
        self.contentMode == UIViewContentModeScaleAspectFit ||
        self.contentMode == UIViewContentModeRedraw)
    {
        size.width = floorf(size.width * scale) / scale;
        size.height = floorf(size.height * scale) / scale;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //
    // Fill background of context
    //
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    //
    // Draw text in the context
    //
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[self fontForText]}];
    CGRect bounds = self.bounds;
    [text drawInRect:CGRectMake(bounds.size.width/2 - textSize.width/2, bounds.size.height/2 - textSize.height/2, textSize.width, textSize.height)
      withAttributes:@{NSFontAttributeName:[self fontForText], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

@end
