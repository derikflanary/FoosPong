//
//  GameViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/9/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GameViewController.h"
#import <PKYStepper/PKYStepper.h>
#import "ChoosePlayersViewController.h"
#import "GameController.h"

static NSString * const playerOneKey = @"playerOneKey";
static NSString * const playerTwoKey = @"playerTwoKey";
static NSString * const playerOneScoreKey = @"playerOneScoreKey";
static NSString * const playerTwoScoreKey = @"playerTwoScoreKey";
static NSString * const playerOneWinKey = @"playerOneWinKey";
static NSString * const playerTwoWinKey = @"playerTwoWinKey";

@interface GameViewController ()

@property (nonatomic, assign) float scoreToWin;
@property (nonatomic, strong) PKYStepper *playerOneStepper;
@property (nonatomic, strong) PKYStepper *playerTwoStepper;
@property (nonatomic, assign) NSNumber *playerOneScore;
@property (nonatomic, assign) NSNumber *playerTwoScore;
@property (nonatomic, assign) BOOL playerOneWin;
@property (nonatomic, assign) BOOL playerTwoWin;
@property (nonatomic, strong) NSDictionary *gameStats;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scoreToWin = 11;
    self.playerOneWin = NO;
    self.playerTwoWin = NO;
    
    UIBarButtonItem * saveGameButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveGamePressed:)];
    self.navigationItem.rightBarButtonItem = saveGameButton;

    
    self.playerOneStepper = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
    self.playerOneStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",self.playerOneName, @(count)];
    };
    [self.playerOneStepper setup];
    self.playerOneStepper.maximum = self.scoreToWin;
    [self.view addSubview:self.playerOneStepper];
    
    self.playerTwoStepper = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
    self.playerTwoStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",self.playerTwoName, @(count)];
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
    self.playerOneScore = [NSNumber numberWithFloat:self.playerOneStepper.value];
    self.playerTwoScore = [NSNumber numberWithFloat:self.playerTwoStepper.value];
    

    if (self.playerOneStepper.value == 11) {
        self.playerOneWin = YES;
        self.gameStats = @{playerOneKey:self.playerOneName,
                           playerTwoKey:self.playerTwoName,
                           playerOneScoreKey:self.playerOneScore,
                           playerTwoScoreKey:self.playerTwoScore,
                           playerOneWinKey:[NSNumber numberWithBool:self.playerOneWin],
                           playerTwoWinKey:[NSNumber numberWithBool:self.playerTwoWin]};
        
    UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", self.playerOneName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
    [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        
//        NSMutableDictionary *mutableStats = self.gameStats.mutableCopy;
//        mutableStats [playerOneWinKey] = [NSNumber numberWithBool: self.playerOneWin];
//        self.gameStats = mutableStats;
        [[GameController sharedInstance]addGameWithDictionary:self.gameStats andUser:self.playerOne];
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [self presentViewController:setTitleAlert animated:YES completion:nil];
    }
    
    if (self.playerTwoStepper.value == 11){
        UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", self.playerTwoName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            self.playerTwoWin = YES;
           
            //[[GameController sharedInstance]addGameWithDictionary:self.gameStats];
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [self presentViewController:setTitleAlert animated:YES completion:nil];
    }// Do any additional setup after loading the view.

   
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


- (void)viewWillDisappear:(BOOL)animated{
    
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
