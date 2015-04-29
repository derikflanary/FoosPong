//
//  SettingViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/26/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SettingViewController.h"
#import "RulesViewController.h"
#import "SettingsSegmentedTableViewCell.h"
#import "SettingsVoiceTableViewCell.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *mySwitch;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UILabel *cellLabel;
@property (nonatomic, assign) BOOL microphoneOff;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:background];
    
    UIBarButtonItem *rulesButton = [[UIBarButtonItem alloc] initWithTitle:@"Rules" style:UIBarButtonItemStylePlain target:self action:@selector(rulesPressed:)];
    self.navigationItem.leftBarButtonItem = rulesButton;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    self.tableView.bounces = NO;
    self.tableView.allowsSelection = NO;

    [self.view addSubview:self.tableView];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:4];
    // Do any additional setup after loading the view.
}

-(void)rulesPressed:(id)sender{
    [self.navigationController pushViewController:[RulesViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 100;
    }else{
        return 100;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Points Per Game";
    }else if (section == 1){
        return @"Voice Command Scoring Disabled";
    }else{
        return @"Other";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsSegmentedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSegmentedCell" ];
    if (!cell){
        cell = [SettingsSegmentedTableViewCell new];
        
    }
    SettingsVoiceTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"SettingsVoiceCell" ];
    if (!cell2){
        cell2 = [SettingsVoiceTableViewCell new];
        
    }
    
    if (indexPath.section == 1) {
        return cell2;

    }else if (indexPath.section == 0){
        return cell;
        
    }
    
        return cell;

}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkGrayColor];
    header.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:16];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.contentView.backgroundColor = [UIColor transparentWhite];
}



- (void)stepperChanged:(id)sender{
    self.pointLabel.text = [NSString stringWithFormat:@"%.f", self.stepper.value];
    
}

- (void)switchSwitched:(id)sender{
    if (self.mySwitch.on) {
        self.microphoneOff = YES;
    }else{
        self.microphoneOff = NO;
    }
    NSNumber *micOff = [NSNumber numberWithBool:self.microphoneOff];
    [[NSUserDefaults standardUserDefaults] setObject:micOff forKey:@"micOff"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
