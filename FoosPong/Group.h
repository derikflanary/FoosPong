//
//  Group.h
//  FoosPong
//
//  Created by Derik Flanary on 3/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) PFUser *admin;



@end
