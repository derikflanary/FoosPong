//
//  GroupStatsViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/20/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamMemberStatsViewController.h"
#import "JBLineChartView.h"
#import "JBChartInformationView.h"
#import "JBChartHeaderView.h"

// Numerics
CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 6.0f;
CGFloat const kJBLineChartViewControllerChartDashedLineWidth = 2.0f;
NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;


@interface TeamMemberStatsViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChart;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) JBChartInformationView *informationView;
@property (nonatomic, strong) NSArray *rankingHistory;


@end

@implementation TeamMemberStatsViewController

- (void)viewDidLoad {
    
    self.navigationController.toolbarHidden = NO;
    [super viewDidLoad];
    
    self.rankingHistory = self.ranking[@"rankHistory"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, [UIColor mainWhite], NSForegroundColorAttributeName, nil]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor mainWhite]];
    self.title = [self.user.username uppercaseString];
    
    self.view.backgroundColor = [UIColor darkColor];
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"1 V 1 Rank", @"1 V 1 Stats", @"2 V 2 Rank", @"2 V 2 Stats"]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor marigoldBrown];
    self.segmentedControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
    [self.segmentedControl sizeToFit];
    
    UIBarButtonItem *seg = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:@[spacer,seg, spacer]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.lineChart = [JBLineChartView new];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
     self.lineChart.frame = CGRectMake(0, 20, self.view.frame.size.width, 300);
    [self.lineChart setMinimumValue:900];
    [self.lineChart setMaximumValue:1100];
    [self.lineChart setHidden:NO];
    
    
   //self.lineChart.headerView = chartHeader;
//    self.lineChart.footerView = nil;
    

   
//    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineChart.frame), self.view.bounds.size.width, self.view.frame.size.height - CGRectGetMaxY(self.lineChart.frame) - 50)];
    [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
    [self.informationView setTitleTextColor:[UIColor vanilla]];
    [self.informationView setTextShadowColor:nil];
    [self.informationView setSeparatorColor:[UIColor lunarGreen]];

    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeaderHeight)];
    headerView.titleLabel.text = @"";
    headerView.titleLabel.textColor = [UIColor vanilla];
    headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.subtitleLabel.text = @"Single's Ranking";
    headerView.subtitleLabel.textColor = [UIColor vanilla];
//    headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
//    headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
    headerView.separatorColor = [UIColor lunarGreen];
//    headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
    self.lineChart.headerView = headerView;

    
    
    [self.lineChart reloadData];
    
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    [bluredEffectView setFrame:self.view.bounds];
//    
//    [self.view addSubview:bluredEffectView];
//    
//     //Vibrancy Effect
//    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//    [vibrancyEffectView setFrame:self.view.bounds];
//    
////     [vibrancyEffectView.contentView addSubview:chartHeader];
//     [vibrancyEffectView.contentView addSubview:self.lineChart];
//     [vibrancyEffectView.contentView addSubview:self.informationView];
//    // Add Vibrancy View to Blur View
//    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    
    [self.view addSubview:self.lineChart];
    [self.view addSubview:self.informationView];

    //[self.view addSubview:self.tableView];

    // Do any additional setup after loading the view.
}



- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
   
  NSNumber *rank = [self.rankingHistory objectAtIndex:horizontalIndex];
    CGFloat rankFloat = [rank floatValue];
    return rankFloat;
}


- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView{
    
    return 1;
}


- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex{
    //NSLog(@"%lu", [self.games count]);
    return [self.rankingHistory count];
}


- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex{
    return lineIndex == JBLineChartViewLineStyleSolid;
}


- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 5; // width of line in chart
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex{
    return YES;
}

#pragma mark - information view

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber = [self.rankingHistory objectAtIndex:horizontalIndex];
    CGFloat rankFloat = [valueNumber floatValue];
    [self.informationView setValueText:[NSString stringWithFormat:@"%.f", rankFloat] unitText:@"Score"];
    
    NSNumber *lastNumber = [self.rankingHistory lastObject];
    if ([valueNumber isEqualToNumber:lastNumber]) {
        [self.informationView setTitleText:@"Current Score"];
    }else{
        [self.informationView setTitleText:@"Previous Score"];
    }
    
    [self.informationView setHidden:NO animated:YES];
   // [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
//    [self.tooltipView setText:[[self.daysOfWeek objectAtIndex:horizontalIndex] uppercaseString]];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.informationView setHidden:YES animated:YES];
    
//    [self setTooltipVisible:NO animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)segmentedControlChangedValue:(id)sender{
    //[self.tableView reloadData];
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