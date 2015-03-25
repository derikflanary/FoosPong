//
//  CustomAccessoryView.m
//  FoosPong
//
//  Created by Derik Flanary on 3/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "CustomAccessoryView.h"

@interface CustomAccessoryView()

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *doneButton;


@end

@implementation CustomAccessoryView



- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.toolbar = [UIToolbar new];
        CGSize toolbarSize = [self.toolbar sizeThatFits:self.toolbar.frame.size];
        self.toolbar.frame = CGRectMake(0, 0, toolbarSize.width, toolbarSize.height);
        self.toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        self.frame = self.toolbar.frame;
        
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTouched)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"35"] style:UIBarButtonItemStylePlain target:self action:@selector(previousButtonPressed)];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"36"] style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed)];
        [self.toolbar setItems:@[prevButton, nextButton, flexibleSpace,self.doneButton]];
        
        [self.toolbar setBarTintColor:[UIColor darkColor]];
        [self.toolbar setTintColor:[UIColor transparentWhite]];
        //        self.doneButton.tintColor = [UIColor whiteColor];
        
        [self addSubview:self.toolbar];
    }
    return self;
}

- (void)doneButtonTouched {
    [self.delegate donePressed];
}

- (void)previousButtonPressed {
    [self.delegate previousPressed];
}

- (void)nextButtonPressed {
    [self.delegate nextPressed];
}

@end

