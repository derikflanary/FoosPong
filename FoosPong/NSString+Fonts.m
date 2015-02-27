//
//  NSString+Fonts.m
//  FoosPong
//
//  Created by Derik Flanary on 2/26/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "NSString+Fonts.h"

@implementation NSString (Fonts)

+ (NSString*)mainFont{
    NSString* fontName = @"Avenir-Book";
    return fontName;

}

+ (NSString*)boldFont{
    NSString* boldFontName = @"Avenir-Black";
    return boldFontName;
}

@end
