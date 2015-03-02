//
//  HistoryViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "NewGameCustomTableViewCell.h"
#import "HistoryViewController.h"
#import "SingleGameController.h"
#import "UserController.h"
#import "TeamGameController.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *singleGames;
@property (nonatomic, strong) NSArray *teamGames;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    

     PFUser *currentUser = [UserController sharedInstance].theCurrentUser;
    [[SingleGameController sharedInstance] updateGamesForUser:currentUser callback:^(NSArray * games){
        self.singleGames = games;
        [self.tableView reloadData];
    }];

    [[TeamGameController sharedInstance] updateGamesForUser:currentUser callback:^(NSArray * teamGames) {
        self.teamGames = teamGames;
        [self.tableView reloadData];
    }];

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [self.singleGames count];
    }else{
        return [self.teamGames count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
    if (section == 0) {
        return @"Single Games";
    }else{
        return @"Team Games";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
   
    PFObject *game = [self.singleGames objectAtIndex:indexPath.row];
    PFUser *p1 = game[@"P1"];
    NSString *p1Name = p1[@"firstName"];
    PFUser *p2 = game[@"P2"];
    NSString *p2Name = p2[@"firstName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@ vs %@:%@", p1Name, game[@"playerOneScore"], p2Name, game[@"playerTwoScore"]];
    return cell;
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
