//
//  TeamGameViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamGameViewController.h"
#import <PKYStepper/PKYStepper.h>
#import "ChoosePlayersViewController.h"
#import "GameController.h"

@interface TeamGameViewController ()

@property (nonatomic, strong)NSArray *teamOne;
@property (nonatomic, strong)NSArray *teamTwo;
@property (nonatomic, strong)PKYStepper *stepperTeamOne;
@property (nonatomic, strong)PKYStepper *stepperTeamTwo;
@property (nonatomic, assign)BOOL *teamOneWin;
@property (nonatomic, assign)BOOL *teamTwoWin;
@property (nonatomic, assign)NSNumber *teamOneScore;
@property (nonatomic, assign)NSNumber *teamTwoScore;

@end

@implementation TeamGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
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
