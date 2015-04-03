//
//  GroupHistoryViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GroupHistoryViewController.h"
#import "GameDetailViewController.h"
#import "SingleGameController.h"
#import "TeamGameController.h"
#import "ODRefreshControl/ODRefreshControl.h"
#import "TeamFeedTableViewCell.h"

@interface GroupHistoryViewController () <UITableViewDataSource, UITableViewDelegate, UIToolbarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *singleGames;
@property (nonatomic, strong) NSArray *teamGames;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) UILabel *messageLabel;


@end

@implementation GroupHistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:background];
    
    UIView *whiteWall = [[UIView alloc]initWithFrame:self.view.bounds];
    whiteWall.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:whiteWall];

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame) + 50, 0.0f);
    

    self.refreshControl = [[ODRefreshControl alloc]initInScrollView:self.tableView];
    self.refreshControl.backgroundColor = [UIColor darkColor];
    self.refreshControl.tintColor = [UIColor darkColor];
    [self.refreshControl addTarget:self
                            action:@selector(pulledToRefresh)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.activityIndicatorViewColor = [UIColor transparentWhite];
    self.refreshControl.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [self.refreshControl beginRefreshing];
    
    [self updateTableView];

    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:3];
    
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

- (void)pulledToRefresh{
   
    [self updateTableView];
}

- (void)updateTableView{
    PFUser *currentUser = [PFUser currentUser];
    
    if (!currentUser[@"currentGroup"]) {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        self.messageLabel.text = @"Not apart of any teams? Join or create a team on the 'Groups' tab.";
        self.messageLabel.textColor = [UIColor darkColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [self.messageLabel sizeToFit];
        
        self.tableView.backgroundView = self.messageLabel;
        [self.refreshControl endRefreshing];
    }else{
        self.messageLabel.text = @"";
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.refreshControl endRefreshing];
        });
    
        [[SingleGameController sharedInstance]updateGamesForGroup:[PFUser currentUser][@"currentGroup"] Callback:^(NSArray *singleGames) {
            
            self.singleGames = singleGames;
            
            [[TeamGameController sharedInstance]updateGamesForGroup:[PFUser currentUser][@"currentGroup"] Callback:^(NSArray *teamGames) {
                
                self.teamGames = teamGames;
                [self.tableView reloadData];
                
                if (self.refreshControl) {
                    
    
                    double delayInSeconds = 1.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.refreshControl endRefreshing];
                    });
                    
                }
                
            }];
        }];
    }if ([self.singleGames count] < 1) {
        [self.refreshControl endRefreshing];
    }
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (![PFUser currentUser][@"currentGroup"]) {
        return 0;
    }
    
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        if ([self.singleGames count] < 1) {
            
            self.messageLabel.text = @"No 1v1 games have been played yet";
            self.messageLabel.textColor = [UIColor darkColor];
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            [self.messageLabel sizeToFit];
            
            return 0;

        }else{
        
            return [self.singleGames count];
        }
    }else{
        if ([self.teamGames count] < 1) {
            self.messageLabel.text = @"No 2v2 games have been played yet";
            self.messageLabel.textColor = [UIColor darkColor];
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            [self.messageLabel sizeToFit];
            
            return 0;
            
        }else{
            
            return [self.teamGames count];
        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TeamFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamFeedCell" ];
    if (!cell){
        cell = [TeamFeedTableViewCell new];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    
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
        cell.dateLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
        
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
        
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
        NSDate *date = teamGame.createdAt;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ & %@: %.0f | %@ & %@: %.0f", t1p1Name, t1p2Name, teamGame.teamOneScore, t2p1Name, t2p2Name, teamGame.teamTwoScore];
        cell.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];

        cell.textLabel.numberOfLines = 0;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
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
    
//    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gameDetailViewController];
//    
//    navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    
//    [self.navigationController presentViewController:navController animated:YES completion:^{
//        
//    }];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.textColor = [UIColor darkColor];
    header.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.contentView.backgroundColor = [UIColor transparentWhite];
}

@end
