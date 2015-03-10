//
//  StatsViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/6/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "StatsViewController.h"
#import "JBLineChartView.h"

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
        
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 50, 300, 100) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    self.lineChart = [JBLineChartView new];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.backgroundColor = [UIColor darkColor];
    self.lineChart.frame = CGRectMake(0, 0, 300, 100);
    [self.lineChart reloadData];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredEffectView setFrame:self.view.bounds];
    
    [self.view addSubview:bluredEffectView];
    
    // Vibrancy Effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    
    [vibrancyEffectView.contentView addSubview:self.tableView];
    [vibrancyEffectView.contentView addSubview:self.lineChart];
    //[vibrancyEffectView.contentView addSubview:self.lineChart];
    // Add Vibrancy View to Blur View
    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (!cell){
        cell = [UITableViewCell new];
    }
    
    cell.backgroundColor = [UIColor whiteColor];

    [cell.contentView addSubview:self.lineChart];
    [self.lineChart sizeToFit];
    cell.textLabel.textColor = [UIColor lightTextColor];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return self.lineChart.frame.size.height;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Stats";
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return 5; // y-position (y-axis) of point at horizontalIndex (x-axis)
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView{
    
    return self.overallStats.totalGamesPlayed;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex{
    return 1;
}


- (void)cancelPressed:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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
