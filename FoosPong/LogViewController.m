//
//  LogViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/19/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "LogViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserController.h"
#import "SignUpViewController.h"
#import "InitialViewController.h"
#import "UserController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"


@interface LogViewController ()<DXCustomInputAccessoryViewDelegate>

@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIView *whiteWall = [[UIView alloc]initWithFrame:self.view.bounds];
    whiteWall.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:whiteWall];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainBlack]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainWhite]];

    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    
    
    
    UIBarButtonItem *otherLogIn = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action:@selector(openSignUp:)];
    self.navigationItem.rightBarButtonItem = otherLogIn;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.usernameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 301, self.view.frame.size.width, 41)];
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
    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(0, 342, self.view.frame.size.width, 41)];
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
    
    self.loginButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 383, self.view.frame.size.width, 62)];
    self.loginButton.backgroundColor = [UIColor darkColor];
    self.loginButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
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
    
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.forgotButton];
    
    CustomAccessoryView *inputAccesoryView = [CustomAccessoryView new];
    inputAccesoryView.delegate = self;
    
    self.usernameField.inputAccessoryView = inputAccesoryView;
    self.passwordField.inputAccessoryView = inputAccesoryView;
    
}

- (void)cancelPressed:(id)sender{
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginPressed:(id)sender{
    [self.view endEditing:YES];

    NSDictionary *dictionary = @{@"username":self.usernameField.text,
                                 @"password":self.passwordField.text};
    [[UserController sharedInstance] loginUser:dictionary callback:^(PFUser *currentUser) {
        if (!currentUser){
            UIAlertController *failedLoginAlert = [UIAlertController alertControllerWithTitle:@"Login Failed" message:@"Either your username or password were incorrect. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            [failedLoginAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                self.passwordField.text = nil;
                return;
            }]];
            [self presentViewController:failedLoginAlert animated:YES completion:nil];
            
        }else{
            
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.mainNavigationController.viewControllers = @[[HomeViewController new]];

            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }];
}

-(void)openSignUp:(id)sender{
    SignUpViewController *lvc = [SignUpViewController new];
    [self.navigationController pushViewController:lvc animated:YES];
}

-(void)dismissKeyboard:(id)sender{
    
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
    if ([self.usernameField isFirstResponder]) {
        [self.passwordField becomeFirstResponder];
    }
}

- (void)previousPressed{
    if ([self.passwordField isFirstResponder]) {
        [self.usernameField becomeFirstResponder];
    }
}





@end
