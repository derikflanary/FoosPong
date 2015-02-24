//
//  MainViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "InitialViewController.h"
#import "HomeViewController.h"
#import "GroupsViewController.h"
#import "ProfileViewController.h"
#import "UserController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SignUpViewController.h"
#import "LogViewController.h"

@interface InitialViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *guestButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HomeViewController *hvc;

@end

@implementation InitialViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem * logInButton = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(logInPressed:)];
//    self.navigationItem.rightBarButtonItem = logInButton;
    
    UIColor* mainColor = [UIColor colorWithRed:189.0/255 green:242.0/255 blue:139.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:1.0f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FoosBallButton"]];
    self.imageView.frame = self.view.frame;
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
    [self.guestButton setTitle:@"Play As Guest" forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.guestButton addTarget:self action:@selector(guestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guestButton];
    
    self.tabBarController = [UITabBarController new];
    self.hvc = [HomeViewController new];
    self.hvc.tabBarItem.title = @"Main";
    GroupsViewController *gvc = [GroupsViewController new];
    gvc.tabBarItem.title = @"Group";
    ProfileViewController *pvc = [ProfileViewController new];
    pvc.tabBarItem.title = @"Profile";
    self.tabBarController.viewControllers = @[self.hvc, gvc, pvc];

}
//-(void)openLogIn:(id)selector{
//    
//    //LoginController4 *signInController = [LoginController4 new];
//    LogViewController *logViewController = [LogViewController new];
//    [self.navigationController pushViewController:logViewController animated:YES];
//}


-(void)loginPressed:(id)selector{
    
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    [self presentViewController:logInController animated:YES completion:nil];
    
}



- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [logInController dismissViewControllerAnimated:YES completion:^{
        [[UserController sharedInstance] findCurrentUser];
        [[UserController sharedInstance] updateUsers];

    }];
    [self.navigationController showViewController:self.tabBarController sender:self];
}

-(void)guestPressed:(id)sender{
    [[UserController sharedInstance] addGuestUser];

    self.hvc.isGuest = YES;
    [self.navigationController pushViewController:self.tabBarController animated:YES];
       
    
    
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
