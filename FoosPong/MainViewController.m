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
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface MainViewController ()<PFLogInViewControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    self.title = currentUser.username;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * logInButton = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(logInPressed:)];
    self.navigationItem.rightBarButtonItem = logInButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    PFUser *currentUser = [PFUser currentUser];
    self.title = currentUser.username;
    
    self.tabBarController = [UITabBarController new];
    PingPongViewController *ppvc = [PingPongViewController new];
    ppvc.tabBarItem.title = @"Main";
    HistoryViewController *hvc = [HistoryViewController new];
    hvc.tabBarItem.title = @"History";
    ProfileViewController *pvc = [ProfileViewController new];
    pvc.tabBarItem.title = @"Profile";
    self.tabBarController.viewControllers = @[ppvc, hvc, pvc];
    // Do any additional setup after loading the view.
    
//    PFObject *testObject = [PFObject objectWithClassName:@"Game"];
//    testObject[@"Score"] = @"11";
//    [testObject saveInBackground];
}

-(void)logInPressed:(id)selector{
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    [self presentViewController:logInController animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [logInController dismissViewControllerAnimated:YES completion:^{
        
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
