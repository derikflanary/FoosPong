//
//  MainViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "MainViewController.h"
#import "PingPongViewController.h"
#import "HistoryViewController.h"
#import "ProfileViewController.h"
#import "UserController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "MySignUpViewController.h"
#import "LoginController4.h"

@interface MainViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![UserController sharedInstance].theCurrentUser) {
        return;
    }else{
    [[UserController sharedInstance] findCurrentUser];
    self.title = [UserController sharedInstance].theCurrentUser.username;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * logInButton = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(logInPressed:)];
    self.navigationItem.rightBarButtonItem = logInButton;
    
//    UIBarButtonItem *otherLogIn = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action:@selector(openLogIn:)];
//    self.navigationItem.rightBarButtonItem = otherLogIn;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    self.tabBarController = [UITabBarController new];
    PingPongViewController *ppvc = [PingPongViewController new];
    ppvc.tabBarItem.title = @"Main";
    HistoryViewController *hvc = [HistoryViewController new];
    hvc.tabBarItem.title = @"History";
    ProfileViewController *pvc = [ProfileViewController new];
    pvc.tabBarItem.title = @"Profile";
    self.tabBarController.viewControllers = @[ppvc, hvc, pvc];
    
}

-(void)openLogIn:(id)selector{
    LoginController4 *signInController = [LoginController4 new];
    [self presentViewController:signInController animated:YES completion:nil];
    [self.navigationController pushViewController:signInController animated:YES];
}


-(void)logInPressed:(id)selector{
    
        MySignUpViewController *signUpController = [[MySignUpViewController alloc] init];
        signUpController.delegate = self;
        signUpController.fields = (PFSignUpFieldsAdditional
                                   | PFSignUpFieldsSignUpButton
                                   | PFSignUpFieldsAdditional
                                   | PFSignUpFieldsUsernameAndPassword
                                   | PFSignUpFieldsDismissButton);
        //[self presentViewController:signUpController animated:YES completion:nil];
   
    
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.signUpController = signUpController;
    [self presentViewController:logInController animated:YES completion:nil];
    
}



- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [logInController dismissViewControllerAnimated:YES completion:^{
        
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
