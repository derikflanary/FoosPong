//
//  GameViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/9/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SingleGameViewController.h"
#import <PKYStepper/PKYStepper.h>
#import "ChoosePlayersViewController.h"
#import "SingleGameController.h"
#import "SingleGameStats.h"

static NSString * const playerOneKey = @"playerOneKey";
static NSString * const playerTwoKey = @"playerTwoKey";
static NSString * const playerOneScoreKey = @"playerOneScoreKey";
static NSString * const playerTwoScoreKey = @"playerTwoScoreKey";
static NSString * const playerOneWinKey = @"playerOneWinKey";
static NSString * const playerTwoWinKey = @"playerTwoWinKey";

@interface SingleGameViewController ()

@property (nonatomic, assign) float scoreToWin;
@property (nonatomic, strong) PKYStepper *playerOneStepper;
@property (nonatomic, strong) PKYStepper *playerTwoStepper;
@property (nonatomic, assign) NSNumber *playerOneScore;
@property (nonatomic, assign) NSNumber *playerTwoScore;
@property (nonatomic, assign) BOOL playerOneWin;
@property (nonatomic, assign) BOOL playerTwoWin;
@property (nonatomic, strong) SingleGameStats *gameStats;
//@property (nonatomic, strong) NSDictionary *gameStats;

@end

@implementation SingleGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    self.scoreToWin = 10;
    self.playerOneWin = NO;
    self.playerTwoWin = NO;
    self.playerOneName = self.playerOne.username;
    self.playerTwoName = self.playerTwo.username;
    
//    UIBarButtonItem * saveGameButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveGamePressed:)];
    //self.navigationItem.rightBarButtonItem = saveGameButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    __block SingleGameViewController *bSelf = self;
    self.playerOneStepper = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    self.playerOneStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",bSelf.playerOneName, @(count)];
    };
    [self.playerOneStepper setup];
    self.playerOneStepper.maximum = self.scoreToWin;
    [self.view addSubview:self.playerOneStepper];
    
    self.playerTwoStepper = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
    self.playerTwoStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",bSelf.playerTwoName, @(count)];
    };
        [self.playerTwoStepper setup];
    self.playerTwoStepper.maximum = self.scoreToWin;
        [self.view addSubview:self.playerTwoStepper];
    
    [self.playerOneStepper.countLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.playerTwoStepper.countLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    
    
       }

-(void)saveGamePressed:(id)sender{
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Save Game" message:@"Would you like to save this game for later?" preferredStyle:UIAlertControllerStyleAlert];
    [saveAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [saveAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [self presentViewController:saveAlert animated:YES completion:nil];

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (self.playerOneStepper.value == self.scoreToWin) {
        
        self.playerOneWin = YES;
        
        [self updateGameStats];
        
        UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", self.playerOneName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
            [[SingleGameController sharedInstance] addGameWithSingleGameStats:self.gameStats];
        
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        
        }]];
        [self presentViewController:setTitleAlert animated:YES completion:nil];
        
    }else if (self.playerTwoStepper.value == self.scoreToWin){
        
        self.playerTwoWin = YES;
        
        [self updateGameStats];
        
        UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", self.playerTwoName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [[SingleGameController sharedInstance] addGameWithSingleGameStats:self.gameStats];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }]];
        [self presentViewController:setTitleAlert animated:YES completion:nil];
    }
}

- (void)updateGameStats{
    
    self.gameStats = [SingleGameStats new];
    self.gameStats.playerOne = self.playerOne;
    self.gameStats.playerTwo = self.playerTwo;
    self.gameStats.playerOneScore = (double)self.playerOneStepper.value;
    self.gameStats.playerTwoScore = (double)self.playerTwoStepper.value;
    self.gameStats.playerOneWin = self.playerOneWin;

}

- (void)dealloc {
    
    [self.playerOneStepper.countLabel removeObserver:self forKeyPath:@"text"];
    [self.playerTwoStepper.countLabel removeObserver:self forKeyPath:@"text"];
    //[super dealloc];
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
