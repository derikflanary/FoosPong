//
//  PingPongViewController.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "PingPongViewController.h"

@interface PingPongViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *pingPongTableView;

@end

@implementation PingPongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pingPongTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.pingPongTableView.dataSource = self;
    self.pingPongTableView.delegate = self;
    
    // Do any additional setup after loading the view.
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
