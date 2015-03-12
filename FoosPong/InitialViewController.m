
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
#import <ParseUI/ParseUI.h>
#import "SignUpViewController.h"
#import "LogViewController.h"



typedef NS_ENUM(NSInteger, SideBarSection) {
    SideBarSectionLogin,
    SideBarSectionMain,
    SideBarSectionPersonal,
    SideBarSectionGroups,
    SideBarSectionSettings,
};

@interface InitialViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabBarControllerProfile;
@property (nonatomic, strong) UITabBarController *tabBarControllerGroup;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *guestButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation InitialViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [PFUser currentUser].username);
//    if ([PFUser currentUser].username) {
//        [[UserController sharedInstance] updateUsers];
//
//    }
    
    UIColor* mainColor = [UIColor mainColor];
    UIColor* darkColor = [UIColor darkColor];
    //NSString* fontName = [NSString mainFont];
    NSString* boldFontName = [NSString boldFont];
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FoosBallButton"]];
    self.imageView.frame = self.view.frame;
    self.imageView.alpha = 1;
    [self.view addSubview:self.imageView];
    
    
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 383, 320, 62)];
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.guestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 320, 62)];
    self.guestButton.backgroundColor = mainColor;
    self.guestButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.guestButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.guestButton addTarget:self action:@selector(signUpPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guestButton];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
}

#pragma mark - Login Buttons

-(void)loginPressed:(id)selector{
    
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    LogViewController *logViewController = [LogViewController new];
    UINavigationController *logNavController = [[UINavigationController alloc]initWithRootViewController:logViewController];
    [self presentViewController:logNavController animated:YES completion:^{
        
    }];
    //[self presentViewController:logInController animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    
    [logInController dismissViewControllerAnimated:YES completion:^{
        //[[UserController sharedInstance] findCurrentUser];
        [[UserController sharedInstance] updateUsers];

    }];
    //[self.navigationController showViewController:self.tabBarController sender:self];
}

-(void)signUpPressed:(id)sender{
    
    SignUpViewController *signUpViewController = [SignUpViewController new];
    UINavigationController *signUpNavController = [[UINavigationController alloc]initWithRootViewController:signUpViewController];

    [self presentViewController:signUpNavController animated:YES completion:nil];
}

-(void)guestPressed:(id)sender{
    [[UserController sharedInstance] addGuestUser];
    HomeViewController *hvc = [HomeViewController new];
    hvc.isGuest = YES;
    self.navigationController.viewControllers = @[hvc];
    
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
