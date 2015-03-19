//
//  LoginController4.h
//  ADVFlatUI
//
//  Created by Tope on 30/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLoginController.h"

@interface SignUpViewController : BaseLoginController

@property (nonatomic, strong) UITextField * usernameField;
@property (nonatomic, strong) UITextField * passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton * forgotButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UIView * infoView;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UIView * overlayView;
@property (nonatomic, strong) UITextField * firstNameField;
@property (nonatomic, strong) UITextField * lastNameField;
@property (nonatomic, strong) UITextField *emailField;


@end
