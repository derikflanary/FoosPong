
//
//  MainViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//


#import "HomeViewController.h"
#import "InitialViewController.h"
#import "UserController.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "LogViewController.h"




typedef NS_ENUM(NSInteger, SideBarSection) {
    SideBarSectionLogin,
    SideBarSectionMain,
    SideBarSectionPersonal,
    SideBarSectionGroups,
    SideBarSectionSettings,
};

@interface InitialViewController ()

@property (nonatomic, strong) UITabBarController *tabBarControllerProfile;
@property (nonatomic, strong) UITabBarController *tabBarControllerGroup;
@property (nonatomic, strong) FoosButton *loginButton;
@property (nonatomic, strong) FoosButton *guestButton;
@property (nonatomic, strong) FoosButton *logOutButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation InitialViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser]) {
        self.loginButton.hidden = YES;
        self.guestButton.hidden = YES;
        self.logOutButton.hidden = NO;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor* darkColor = [UIColor darkColor];
    NSString* boldFontName = [NSString boldFont];
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    self.imageView.frame = self.view.frame;
    self.imageView.alpha = 1;
    [self.view addSubview:self.imageView];
    
    UIView *whiteWall = [[UIView alloc]initWithFrame:self.view.bounds];
    whiteWall.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:whiteWall];
    
    
    self.loginButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 383, self.view.frame.size.width, 62)];
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.loginButton setTintColor: [UIColor blackColor]];
    [self.loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.guestButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 62)];
    self.guestButton.backgroundColor = darkColor;
    self.guestButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.guestButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.guestButton addTarget:self action:@selector(signUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guestButton];
    
    self.logOutButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 62)];
    self.logOutButton.backgroundColor = darkColor;
    self.logOutButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.logOutButton setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [self.logOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logOutButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.logOutButton addTarget:self action:@selector(logOutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logOutButton];
    self.logOutButton.hidden = YES;

    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
}

#pragma mark - Login Buttons

- (void)logOutPressed:(id)sender{
    self.loginButton.hidden = NO;
    self.guestButton.hidden = NO;
    self.logOutButton.hidden = YES;
    
    [PFUser logOut];
}

-(void)loginPressed:(id)selector{
    
    LogViewController *logViewController = [LogViewController new];
    UINavigationController *logNavController = [[UINavigationController alloc]initWithRootViewController:logViewController];
    [self presentViewController:logNavController animated:YES completion:^{
        
    }];
    //[self presentViewController:logInController animated:YES completion:nil];
}

-(void)signUpPressed:(id)sender{
    
    SignUpViewController *signUpViewController = [SignUpViewController new];
    UINavigationController *signUpNavController = [[UINavigationController alloc]initWithRootViewController:signUpViewController];

    [self presentViewController:signUpNavController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
