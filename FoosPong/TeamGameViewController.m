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
#import "SingleGameController.h"
#import "TeamGameStats.h"
#import "TeamGameController.h"

@interface TeamGameViewController ()

@property (nonatomic, strong) PKYStepper *stepperTeamOne;
@property (nonatomic, strong) PKYStepper *stepperTeamTwo;
@property (nonatomic, assign) BOOL teamOneWin;
@property (nonatomic, assign) NSNumber *teamOneScore;
@property (nonatomic, assign) NSNumber *teamTwoScore;
@property (nonatomic, assign) float scoreToWin;
@property (nonatomic, strong) NSString *t1p1;
@property (nonatomic, strong) NSString *t1p2;
@property (nonatomic, strong) NSString *t2p1;
@property (nonatomic, strong) NSString *t2p2;
@property (nonatomic, strong) TeamGameStats *gameStats;

@end

@implementation TeamGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scoreToWin = 10;
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    PFUser *player = [self.teamOne objectAtIndex:0];
    self.t1p1 = player.username;
    player = [self.teamOne objectAtIndex:1];
    self.t1p2 = player.username;
    player = [self.teamTwo objectAtIndex:0];
    self.t2p1 = player.username;
    player = [self.teamTwo objectAtIndex:1];
    self.t2p2 = player.username;
    
    //Stepper 1
    __block TeamGameViewController *bSelf = self;
    self.stepperTeamOne = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    self.stepperTeamOne.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",[NSString stringWithFormat:@"%@ & %@",bSelf.t1p1, bSelf.t1p2], @(count)];
    };
    [self.stepperTeamOne setup];
    self.stepperTeamOne.maximum = self.scoreToWin;
    [self.view addSubview:self.stepperTeamOne];
    
    //Stepper 2
    self.stepperTeamTwo = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
    self.stepperTeamTwo.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",[NSString stringWithFormat:@"%@ & %@",bSelf.t2p1, bSelf.t2p2], @(count)];
    };
    [self.stepperTeamTwo setup];
    self.stepperTeamTwo.maximum = self.scoreToWin;
    [self.view addSubview:self.stepperTeamTwo];
    

    [self.stepperTeamOne.countLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.stepperTeamTwo.countLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (self.stepperTeamOne.value == self.scoreToWin) {
        
        self.teamOneWin = YES;
        [self updateTeamGameStats];
        
        UIAlertController *winnerAlert = [UIAlertController alertControllerWithTitle:@"Team One Wins!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [[TeamGameController sharedInstance] addGameWithTeamGameStats:self.gameStats];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }]];
        [self presentViewController:winnerAlert animated:YES completion:nil];
        
    }else if (self.stepperTeamTwo.value == self.scoreToWin){
        
        self.teamOneWin = NO;
        [self updateTeamGameStats];
        
        UIAlertController *winnerAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Team Two Wins!"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [[TeamGameController sharedInstance] addGameWithTeamGameStats:self.gameStats];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }]];
        [self presentViewController:winnerAlert animated:YES completion:nil];
    }

}


- (void)updateTeamGameStats{
    
    
    
    self.gameStats = [TeamGameStats new];
    self.gameStats.teamOnePlayerOne = [self.teamOne objectAtIndex:0];
    self.gameStats.teamOnePlayerTwo = [self.teamOne objectAtIndex:1];
    self.gameStats.teamTwoPlayerOne = [self.teamTwo objectAtIndex:0];
    self.gameStats.teamTwoPlayerTwo = [self.teamTwo objectAtIndex:1];
    self.gameStats.teamOneScore =  (double)self.stepperTeamOne.value;
    self.gameStats.teamTwoScore =  (double)self.stepperTeamTwo.value;
    self.gameStats.teamOneWin = [NSNumber numberWithBool:self.teamOneWin];
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
