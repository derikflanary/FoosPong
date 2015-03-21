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
#import "Game.h"
#import "TeamGame.h"
#import "GameDetailViewController.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *singleGames;
@property (nonatomic, strong) NSArray *teamGames;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    self.tableView.bounces = NO;
    
    
        [[SingleGameController sharedInstance] updateGamesForUser:[PFUser currentUser] withBool:NO callback:^(NSArray *games) {
            self.singleGames = games;
            
            [[TeamGameController sharedInstance]updateGamesForUser:[PFUser currentUser] callback:^(NSArray * teamGames) {
                self.teamGames = teamGames;
                [self.tableView reloadData];
            }];
            
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
    if (indexPath.section == 0) {
        
        Game *game = [self.singleGames objectAtIndex:indexPath.row];
        PFUser *p1 = game.p1;
        PFUser *p2 = game.p2;

        NSString *p1Name = p1.username;
        NSString *p2Name = p2.username;
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%.0f vs %@:%.0f", p1Name, game.playerOneScore, p2Name, game.playerTwoScore];
        cell.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
        //cell.backgroundColor = [UIColor mainColor];
        return cell;

    }else{
        
        TeamGame *teamGame = [self.teamGames objectAtIndex:indexPath.row];
        PFUser *t1p1 = teamGame.teamOnePlayerOne;
        NSString *t1p1Name = t1p1.username;
        PFUser *t1p2 = teamGame.teamOnePlayerTwo;
        NSString *t1p2Name = t1p2.username;
        PFUser *t2p1 = teamGame.teamTwoPlayerOne;
        NSString *t2p1Name = t2p1.username;
        PFUser *t2p2 = teamGame.teamTwoPlayerTwo;
        NSString *t2p2Name = t2p2.username;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ & %@: %.0f | %@ & %@: %.0f", t1p1Name, t1p2Name, teamGame.teamOneScore, t2p1Name, t2p2Name, teamGame.teamTwoScore];
        cell.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:16];
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GameDetailViewController *gameDetailViewController = [GameDetailViewController new];
    
    if (indexPath.section == 0) {
        gameDetailViewController.singleGame = [self.singleGames objectAtIndex:indexPath.row];
    }else{
        gameDetailViewController.teamGame = [self.teamGames objectAtIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gameDetailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self.navigationController presentViewController:navController animated:YES completion:^{
        
    }];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkGrayColor];
    header.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.contentView.backgroundColor = [UIColor transparentWhite];
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
