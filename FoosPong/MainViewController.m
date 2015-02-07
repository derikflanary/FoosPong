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

@interface MainViewController ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController = [UITabBarController new];
    PingPongViewController *ppvc = [PingPongViewController new];
    ppvc.tabBarItem.title = @"Main";
    HistoryViewController *hvc = [HistoryViewController new];
    hvc.tabBarItem.title = @"History";
    self.tabBarController.viewControllers = @[ppvc, hvc];
    // Do any additional setup after loading the view.
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
