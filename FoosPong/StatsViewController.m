//
//  StatsViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/6/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "StatsViewController.h"
#import "JBLineChartView.h"
#import "Game.h"
#import "TeamGame.h"

@interface StatsViewController () <UITableViewDataSource, UITableViewDelegate, JBLineChartViewDataSource, JBLineChartViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JBLineChartView *lineChart;

@end

@implementation StatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor mainWhite]];
        
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height- 100) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;
    
    self.lineChart = [JBLineChartView new];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    [self.lineChart setMinimumValue:0];
    [self.lineChart setMaximumValue:10];

    [self.lineChart reloadData];
    
    self.view.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:self.tableView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredEffectView setFrame:self.view.bounds];
    
    [self.view addSubview:bluredEffectView];
    
    // Vibrancy Effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    
    [vibrancyEffectView.contentView addSubview:self.tableView];
    
        // Add Vibrancy View to Blur View
    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.buttonSelected == 1) {
        return [self.personalSingleStats.statArray count];
    }else if (self.buttonSelected == 2){
        return [self.personalTeamStats.teamStatsArray count];
    }else{
        return [self.overallStats.overallStatsArray count];
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (!cell){
        cell = [UITableViewCell new];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0 ) {
        [cell.contentView addSubview:self.lineChart];
        [cell.contentView sizeToFit];

    }else{
        if (self.buttonSelected == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[self.personalSingleStats.statArray lastObject][indexPath.row - 1], self.personalSingleStats.statArray[indexPath.row - 1]];

        }else if (self.buttonSelected == 2){
            cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [self.personalTeamStats.teamStatsArray lastObject][indexPath.row - 1], self.personalTeamStats.teamStatsArray[indexPath.row - 1]];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [self.overallStats.overallStatsArray lastObject][indexPath.row - 1], self.overallStats.overallStatsArray[indexPath.row - 1]];
        }
    }
    
    cell.textLabel.textColor = [UIColor lightTextColor];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.lineChart.frame.size.height;
    }else{
        return 50;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Stats";
}

#pragma mark - LineChart

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
        //NSLog(@"%f",game.playerOneScore)
    if (self.buttonSelected == 1) {
        Game *game = [self.games objectAtIndex:horizontalIndex];
        return (CGFloat)game.playerOneScore;
    }else{
        TeamGame *teamGame = [self.games objectAtIndex:horizontalIndex];
        return (CGFloat)teamGame.teamOneScore;
    }

}


- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView{
    
    return 2;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex{
    //NSLog(@"%lu", [self.games count]);
    return [self.games count] ;
}


- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex{
    return lineIndex == JBLineChartViewLineStyleDashed;
}


- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 3; // width of line in chart
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
