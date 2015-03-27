//
//  NSString+Extensions.m
//  FoosPong
//
//  Created by Derik Flanary on 2/19/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+ (NSString*)combineNames:(NSString*)firstName and:(NSString*)lastName{
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName,lastName];
    return fullName;
}

+ (NSString*)cleanUpError:(NSError *)error{
    
    NSInteger code = [error code];
    if (code == kPFErrorUsernameTaken){
        return @"Username Taken";
    }
    
    if (code == kPFErrorInvalidEmailAddress) {
        return @"Please enter a valid email address";
    }
    
    if (code == kPFErrorUserEmailTaken) {
        return @"Email already in use";
    }
    else{
        return [error userInfo][@"error"];
    }
    
}


@end
