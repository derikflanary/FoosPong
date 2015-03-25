//
//  CustomAccessoryView.h
//  FoosPong
//
//  Created by Derik Flanary on 3/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DXCustomInputAccessoryViewDelegate;

@interface CustomAccessoryView : UIView

@property (nonatomic, weak) id<DXCustomInputAccessoryViewDelegate> delegate;

@end

@protocol DXCustomInputAccessoryViewDelegate <NSObject>

- (void)donePressed;
- (void)previousPressed;
- (void)nextPressed;

@end