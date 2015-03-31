//
//  HistoryViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "HistoryViewController.h"
#import "SingleGameController.h"
#import "UserController.h"
#import "TeamGameController.h"
#import "Game.h"
#import "TeamGame.h"
#import "GameDetailViewController.h"
#import "HistoryTableViewCell.h"
#import "TeamFeedTableViewCell.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate, UIToolbarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *singleGames;
@property (nonatomic, strong) NSArray *teamGames;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = CGPointMake(160, 240);
    self.activityView.color = [UIColor darkColor];
    self.activityView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:background];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
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
                [self.activityView stopAnimating];
                [self.tableView reloadData];
            }];
            
        }];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:2];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"1 V 1", @"2 V 2"]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor darkColor];
    self.segmentedControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
    

    UIBarButtonItem *seg = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [self setToolbarItems:@[spacer,seg, spacer]];

    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setItems:@[spacer, seg, spacer]];
    [self.view addSubview:toolBar];
    toolBar.delegate = self;
    
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar{
    return UIBarPositionTop;
}

- (void)segmentedControlChangedValue:(id)sender{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return [self.singleGames count];
    }else{
        return [self.teamGames count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return @"Single Games";
    }else{
        return @"Team Games";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" ];
    if (!cell){
        cell = [TeamFeedTableViewCell new];
    }
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        Game *game = [self.singleGames objectAtIndex:indexPath.row];
        PFUser *p1 = game.p1;
        PFUser *p2 = game.p2;
        NSDate *date =  game.createdAt;

        NSString *p1Name = p1.username;
        NSString *p2Name = p2.username;
        cell.playerOneLabel.text = [p1Name uppercaseString];
        cell.playerTwoLabel.text = [p2Name uppercaseString];
        cell.playerOneScoreLabel.text = [NSString stringWithFormat:@"%.f", game.playerOneScore];
        cell.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%.f", game.playerTwoScore];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
                //cell.backgroundColor = [UIColor mainColor];
        return cell;

    }else{
        
        TeamGame *teamGame = [self.teamGames objectAtIndex:indexPath.row];
        PFUser *t1p1 = teamGame.teamOneAttacker;
        NSString *t1p1Name = t1p1.username;
        PFUser *t1p2 = teamGame.teamOneDefender;
        NSString *t1p2Name = t1p2.username;
        PFUser *t2p1 = teamGame.teamTwoAttacker;
        NSString *t2p1Name = t2p1.username;
        PFUser *t2p2 = teamGame.teamTwoDefender;
        NSString *t2p2Name = t2p2.username;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ & %@: %.0f | %@ & %@: %.0f", t1p1Name, t1p2Name, teamGame.teamOneScore, t2p1Name, t2p2Name, teamGame.teamTwoScore];
        cell.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GameDetailViewController *gameDetailViewController = [GameDetailViewController new];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
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
