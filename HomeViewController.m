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
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, assign) NSIndexPath *selectedIndexPath;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    if (self.isGuest) {
        self.title = @"Guest";
        
    }else{
        
    }
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    PFUser *user = [PFUser currentUser];
    self.title = [user[@"firstName"] uppercaseString];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIView *whiteWall = [[UIView alloc]initWithFrame:self.view.bounds];
    whiteWall.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:whiteWall];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.pingPongTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.pingPongTableView.dataSource = self;
    self.pingPongTableView.delegate = self;
    self.pingPongTableView.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:self.pingPongTableView];
    self.pingPongTableView.scrollEnabled = NO;
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
//    self.pingPongTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark - TableView Datasource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
    //return [self.projects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"CREATE A NEW GAME";
        cell.textLabel.textColor = [UIColor darkColor];
        cell.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:20];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.detailTextLabel.text = @"Click Here";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"Add A Completed Game";
    }else{
        cell.textLabel.text = @"Continue Saved Game";
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor darkColor];
    return cell;
    
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoosePlayersViewController * newGameViewController = [ChoosePlayersViewController new];
    
    if (indexPath.row == 0) {
        newGameViewController.isLiveGame = YES;
    }else{
        newGameViewController.isLiveGame = NO;
    }
    
    [self.navigationController pushViewController:newGameViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
