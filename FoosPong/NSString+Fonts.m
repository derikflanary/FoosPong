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
    NSString* fontName = @"Thonburi-Light";
    return fontName;

}

+ (NSString*)boldFont{
    NSString* boldFontName = @"Thonburi-Bold ";
    return boldFontName;
}

@end
