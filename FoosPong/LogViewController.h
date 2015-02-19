//
//  LogViewController.h
//  FoosPong
//
//  Created by Derik Flanary on 2/19/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "BaseLoginController.h"

@interface LogViewController : BaseLoginController

@property (nonatomic, strong) UITextField * usernameField;

@property (nonatomic, strong) UITextField * passwordField;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton * forgotButton;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * headerImageView;

@property (nonatomic, strong) UIView * infoView;

@property (nonatomic, strong) UILabel * infoLabel;

@property (nonatomic, strong) UIView * overlayView;

@end
