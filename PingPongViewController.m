//
//  PingPongViewController.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "PingPongViewController.h"
#import "HistoryViewController.h"
#import "ChoosePlayersViewController.h"
#import "NewGameCustomTableViewCell.h"

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
    self.pingPongTableView.scrollEnabled = YES;
    
    //[self.pingPongTableView registerClass:[UITableView class] forCellWithReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view.
}
#pragma mark - TableView Datasource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  2;
    //return [self.projects count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
       cell.textLabel.text = @"New Game";
    return cell;
    
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 400;
    }else{
        return 200;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePlayersViewController * newGameViewController = [ChoosePlayersViewController new];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:newGameViewController animated:YES];
    }
    NSLog(@"%ld", (long)indexPath.row);
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
