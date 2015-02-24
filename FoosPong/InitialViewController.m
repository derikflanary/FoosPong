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

@end

@implementation InitialViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    PFUser *user = [PFUser currentUser];
    self.title = user[@"firstName"];
   [[UserController sharedInstance] updateUsers];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * logInButton = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(logInPressed:)];
    self.navigationItem.rightBarButtonItem = logInButton;
//    
//    UIBarButtonItem *otherLogIn = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(openLogIn:)];
//    self.navigationItem.rightBarButtonItem = otherLogIn;
//    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
    
    
    self.tabBarController = [UITabBarController new];
    HomeViewController *ppvc = [HomeViewController new];
    ppvc.tabBarItem.title = @"Main";
    GroupsViewController *gvc = [GroupsViewController new];
    gvc.tabBarItem.title = @"Group";
    ProfileViewController *pvc = [ProfileViewController new];
    pvc.tabBarItem.title = @"Profile";
    self.tabBarController.viewControllers = @[ppvc, gvc, pvc];
    
}

-(void)openLogIn:(id)selector{
    
    //LoginController4 *signInController = [LoginController4 new];
    LogViewController *logViewController = [LogViewController new];
    [self.navigationController pushViewController:logViewController animated:YES];
}


-(void)logInPressed:(id)selector{
    
    
    
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    [self presentViewController:logInController animated:YES completion:nil];
    
}



- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [logInController dismissViewControllerAnimated:YES completion:^{
        [[UserController sharedInstance] findCurrentUser];
        [[UserController sharedInstance] updateUsers];

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pingPongPressed:(id)sender {
    
    
    //PingPongViewController * pingPongController = [PingPongViewController new];
    [self.navigationController pushViewController:self.tabBarController animated:YES];
}
- (IBAction)foosBallPressed:(id)sender {
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
