//
//  PingPongViewController.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "PingPongViewController.h"
#import "HistoryViewController.h"

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
    [self.view addSubview:self.pingPongTableView];
    self.pingPongTableView.scrollEnabled = NO;
    
    //[self.pingPongTableView registerClass:[UITableView class] forCellWithReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
    //return [self.projects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 400;
    }else{
        return 200;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell One"];
    if (!cell){
        cell = [UITableViewCell new];
    }
    
    cell.textLabel.text = @"New Game";
    return cell;
    
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
