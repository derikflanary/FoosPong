//
//  SettingViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/26/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SettingViewController.h"
#import "RulesViewController.h"
#import "SettingsTableViewCell.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *mySwitch;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UILabel *cellLabel;
@property (nonatomic, assign) BOOL microphoneOff;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIBarButtonItem *rulesButton = [[UIBarButtonItem alloc] initWithTitle:@"Rules" style:UIBarButtonItemStylePlain target:self action:@selector(rulesPressed:)];
    self.navigationItem.rightBarButtonItem = rulesButton;
    
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
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Voice Command Scoring Off";
    }else if (section == 1){
        return @"Other";
    }else{
        return @"Points Per Game";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" ];
    if (!cell){
        cell = [SettingsTableViewCell new];
        
    }
    if (indexPath.section == 0) {
        self.mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(250, 50, 50, 50)];
        self.mySwitch.onTintColor = [UIColor darkColor];
        [self.mySwitch addTarget:self action:@selector(switchSwitched:) forControlEvents:UIControlEventValueChanged];
        
        NSNumber *micOff = [[NSUserDefaults standardUserDefaults]objectForKey:@"micOff"];
        BOOL microphoneOff = micOff.boolValue;
        if (!microphoneOff) {
            self.mySwitch.on = NO;
        }else{
            self.mySwitch.on = YES;
        }
        self.cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 240, 100)];
        self.cellLabel.text = @"Voice Scoring Off: To use the voice scoring commands during a 1v1 game you can say 'Player One Goal', or 'Player Two Goal' to add a point for either player. During a 2v2 game you can say 'Team One Goal' or 'Team Two Goal'.";
        self.cellLabel.font = [UIFont fontWithName:[NSString mainFont] size:12];
        self.cellLabel.numberOfLines = 0;
        
        [cell.contentView addSubview:self.mySwitch];
        [cell.contentView addSubview:self.cellLabel];

    }else if(indexPath.section == 2){
        self.stepper = [[UIStepper alloc]initWithFrame:CGRectMake(220, 10, 50, 50)];
        [self.stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
        self.stepper.tintColor = [UIColor darkColor];
        
        self.pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 40, 50)];
        self.pointLabel.font = [UIFont fontWithName:[NSString mainFont] size:20];

        self.pointLabel.text = [NSString stringWithFormat:@"%.f", self.stepper.value];
        [cell.contentView addSubview:self.pointLabel];
        [cell.contentView addSubview:self.stepper];
    }
    
        return cell;

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
