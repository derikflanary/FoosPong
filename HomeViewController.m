//
//  PingPongViewController.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "HomeViewController.h"
#import "ChoosePlayersViewController.h"
#import "NewGameCustomTableViewCell.h"
#import "UserController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *pingPongTableView;
@property (nonatomic, strong) HomeViewController *hvc;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    if (self.isGuest) {
        self.title = @"Guest";
        
    }else{
        PFUser *user = [PFUser currentUser];
        self.title = user[@"firstName"];
        [[UserController sharedInstance] updateUsers];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem * sideBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"17"] style:UIBarButtonItemStylePlain target:self action:@selector(sideBarButtonPressed:)];
//    self.navigationItem.rightBarButtonItem = sideBarButton;
    self.navigationItem.hidesBackButton = YES;
    
    self.pingPongTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.pingPongTableView.dataSource = self;
    self.pingPongTableView.delegate = self;
    [self.view addSubview:self.pingPongTableView];
    self.pingPongTableView.scrollEnabled = NO;
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
}
#pragma mark - TableView Datasource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  3;
    //return [self.projects count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Create A New Game";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"Add A Game";
    }else{
        cell.textLabel.text = @"Continue Saved Game";
    }

    return cell;
    
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePlayersViewController * newGameViewController = [ChoosePlayersViewController new];
    
    [self.navigationController pushViewController:newGameViewController animated:YES];
//    if (indexPath.row == 0) {
//        [self.navigationController presentViewController:newGameViewController animated:YES completion:^{
//            
//        }];
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SideBar


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
