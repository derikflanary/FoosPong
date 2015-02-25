//
//  PingPongViewController.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "HomeViewController.h"
#import "HistoryViewController.h"
#import "ChoosePlayersViewController.h"
#import "NewGameCustomTableViewCell.h"
#import "UserController.h"
#import "GroupsViewController.h"
#import "ProfileViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, RNFrostedSidebarDelegate>

@property (nonatomic, strong) UITableView *pingPongTableView;
@property (nonatomic, strong) RNFrostedSidebar *sideBar;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) HomeViewController *hvc;
@property (nonatomic, strong) ProfileViewController *pvc;
@property (nonatomic, strong) GroupsViewController *gvc;

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
    UIBarButtonItem * sideBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"17"] style:UIBarButtonItemStylePlain target:self action:@selector(sideBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = sideBarButton;
    self.navigationItem.hidesBackButton = YES;
    
    self.pingPongTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.pingPongTableView.dataSource = self;
    self.pingPongTableView.delegate = self;
    [self.view addSubview:self.pingPongTableView];
    self.pingPongTableView.scrollEnabled = YES;
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    //[self.pingPongTableView registerClass:[UITableView class] forCellWithReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view.
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
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:newGameViewController animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SideBar

- (void)sideBarButtonPressed:(id)sender{
    NSArray *barImages = @[ [UIImage imageNamed:@"68"],
                            [UIImage imageNamed:@"85"],
                            [UIImage imageNamed:@"74"],
                            [UIImage imageNamed:@"70"],
                            [UIImage imageNamed:@"101"]];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1]];
    
    self.hvc = [HomeViewController new];
    self.gvc = [GroupsViewController new];
    self.pvc = [ProfileViewController new];
    self.sideBar = [[RNFrostedSidebar alloc] initWithImages:barImages selectedIndices:self.optionIndices borderColors:colors];
    self.sideBar.showFromRight = YES;
    self.sideBar.delegate = self;
    [self.sideBar showAnimated:YES];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index{
    
    if (index == 1) {
        [sidebar dismissAnimated:YES];
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                [self.navigationController pushViewController:self.hvc animated:YES];
            }
        }];
    }
    
    if (index == 2) {
        [sidebar dismissAnimated:YES];
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                [self.navigationController pushViewController:self.pvc animated:YES];
            }
        }];
    }
    if (index == 3) {
        [sidebar dismissAnimated:YES];
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                [self.navigationController pushViewController:self.gvc animated:YES];
            }
        }];
    }
    
    
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
