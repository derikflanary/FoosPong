//
//  LoginController4.m
//  ADVFlatUI
//
//  Created by Tope on 30/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "LogViewController.h"
#import "NSString+Extensions.h"

@interface SignUpViewController () <DXCustomInputAccessoryViewDelegate>

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainWhite]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *otherLogIn = [[UIBarButtonItem alloc] initWithTitle:@"Already Signed Up" style:UIBarButtonItemStylePlain target:self action:@selector(openLogIn:)];
    self.navigationItem.rightBarButtonItem = otherLogIn;
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];

    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor mainColor];
    
    self.firstNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 180, 320, 41)];
    self.firstNameField.backgroundColor = [UIColor whiteColor];
    self.firstNameField.placeholder = @"First Name";
    self.firstNameField.font = [UIFont fontWithName:[NSString mainFont] size:16.0f];
    self.firstNameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.firstNameField.layer.borderWidth = 1.0f;
    self.firstNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.firstNameField.leftViewMode = UITextFieldViewModeAlways;
    self.firstNameField.leftView = leftView3;
    
    self.lastNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 220, 320, 41)];
    self.lastNameField.backgroundColor = [UIColor whiteColor];
    self.lastNameField.placeholder = @"Last Name";
    self.lastNameField.font = [UIFont fontWithName:[NSString mainFont] size:16.0f];
    self.lastNameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.lastNameField.layer.borderWidth = 1.0f;
    self.lastNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    UIView* leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.lastNameField.leftViewMode = UITextFieldViewModeAlways;
    self.lastNameField.leftView = leftView4;

    self.emailField = [[UITextField alloc]initWithFrame:CGRectMake(0, 260, 320, 41)];
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.placeholder = @"Email";
    self.emailField.font = [UIFont fontWithName:[NSString mainFont] size:16.0f];
    self.emailField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.emailField.layer.borderWidth = 1.0f;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    UIView* leftView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    self.emailField.leftView = leftView5;
    
    self.usernameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 301, 320, 41)];
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.placeholder = @"Username";
    self.usernameField.font = [UIFont fontWithName:[NSString mainFont] size:16.0f];
    self.usernameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.usernameField.layer.borderWidth = 1.0f;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    //self.usernameField.frame = CGRectMake(0, 220, 320, 41);
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView = leftView;
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(0, 342, 320, 41)];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:[NSString mainFont] size:16.0f];
    self.passwordField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.passwordField.layer.borderWidth = 1.0f;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.secureTextEntry = YES;
    
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView2;
    
    self.loginButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 383, 320, 62)];
    self.loginButton.backgroundColor = [UIColor darkColor];
    self.loginButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.loginButton setTitle:@"SIGN UP HERE" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:[NSString mainFont] size:12.0f];
    [self.forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor darkColor] forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(43, 97, 243, 60)];
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.font =  [UIFont fontWithName:[NSString boldFont] size:24.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"FOOS";
    
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:[NSString boldFont] size:14.0f];
    self.infoLabel.text = @"Welcome back, please login below";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    self.headerImageView.image = [UIImage imageNamed:@"running.jpg"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    
    [self.forgotButton addTarget:self action:@selector(toggleNav:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.firstNameField];
    [self.view addSubview:self.lastNameField];
    [self.view addSubview:self.emailField];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.overlayView];
    
    CustomAccessoryView *inputAccesoryView = [CustomAccessoryView new];
    inputAccesoryView.delegate = self;
    self.firstNameField.inputAccessoryView = inputAccesoryView;
    self.lastNameField.inputAccessoryView = inputAccesoryView;
    self.emailField.inputAccessoryView = inputAccesoryView;
    self.usernameField.inputAccessoryView = inputAccesoryView;
    self.passwordField.inputAccessoryView = inputAccesoryView;
}

-(void)cancelPressed:(id)sender{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)loginPressed:(id)sender{
    
    if ([self.firstNameField.text isEqualToString:@""] || !self.lastNameField.text || !self.usernameField.text || !self.passwordField.text) {
        UIAlertController *missingTextAlert = [UIAlertController alertControllerWithTitle:@"Missing Information" message:@"Please fill out every section" preferredStyle:UIAlertControllerStyleAlert];
        [missingTextAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            return;
        }]];
        [self presentViewController:missingTextAlert animated:YES completion:nil];
    }
    
    NSDictionary *dictionary = @{@"firstName": self.firstNameField.text,
                                 @"lastName": self.lastNameField.text,
                                 @"username": self.usernameField.text,
                                 @"password": self.passwordField.text,
                                 @"email": self.emailField.text};
    
    [[UserController sharedInstance] addUserwithDictionary:dictionary Callback:^(BOOL *succeeded, NSError *error) {
        
        if (succeeded) {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.mainNavigationController.viewControllers = @[[HomeViewController new]];
            [self dismissViewControllerAnimated:YES completion:^{
            }];

        }else{
            UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", [NSString cleanUpError:error]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                return;
            }]];
            [self presentViewController:errorAlert animated:YES completion:nil];
        }
    }];
    
}

- (void)openLogIn:(id)sender{
    LogViewController *lvc = [LogViewController new];
    [self.navigationController pushViewController:lvc animated:YES];
}

-(void)dismissKeyboard:(id)sender{
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

-(IBAction)toggleNav:(id)sender{
    
    BOOL hidden = !self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)donePressed{
    [self.view endEditing:YES];
}

- (void)nextPressed{
    if ([self.firstNameField isFirstResponder]) {
        [self.lastNameField becomeFirstResponder];
    }else if ([self.lastNameField isFirstResponder]){
        [self.emailField becomeFirstResponder];
    }else if ([self.emailField isFirstResponder]){
        [self.usernameField becomeFirstResponder];
    }else if ([self.usernameField isFirstResponder]){
        [self.passwordField becomeFirstResponder];
    }else{
        [self loginPressed:self];
    }
}

- (void)previousPressed{
    
    if ([self.passwordField isFirstResponder]) {
        [self.usernameField becomeFirstResponder];
    }else if ([self.usernameField isFirstResponder]){
        [self.emailField becomeFirstResponder];
    }else if ([self.emailField isFirstResponder]){
        [self.lastNameField becomeFirstResponder];
    }else if ([self.lastNameField isFirstResponder]){
        [self.firstNameField becomeFirstResponder];
    }
}

@end
