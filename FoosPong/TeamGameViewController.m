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
@property (nonatomic, assign)float scoreToWin;
@end

@implementation TeamGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scoreToWin = 10;
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    // Do any additional setup after loading the view.
    
    //Stepper 1
    //__block TeamGameViewController *bSelf = self;
    self.stepperTeamOne = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    self.stepperTeamOne.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",@"Team One", @(count)];
    };
    [self.stepperTeamOne setup];
    self.stepperTeamOne.maximum = self.scoreToWin;
    [self.view addSubview:self.stepperTeamOne];
    
    //Stepper 2
    self.stepperTeamTwo = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
    self.stepperTeamTwo.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",@"Team Two", @(count)];
    };
    [self.stepperTeamTwo setup];
    self.stepperTeamTwo.maximum = self.scoreToWin;
    [self.view addSubview:self.stepperTeamTwo];
    
    [self.stepperTeamOne.countLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.stepperTeamTwo.countLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
}

- (void)dealloc {
    
    [self.stepperTeamOne.countLabel removeObserver:self forKeyPath:@"text"];
    [self.stepperTeamTwo.countLabel removeObserver:self forKeyPath:@"text"];
    //[super dealloc];
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
