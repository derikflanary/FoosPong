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

@interface GameViewController ()

@property (nonatomic, assign) float scoreToWin;
@property (nonatomic, strong) PKYStepper *playerOneStepper;
@property (nonatomic, strong) PKYStepper *playerTwoStepper;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scoreToWin = 11;
    
    
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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"label changed");
    
    if (self.playerOneStepper.value == 11) {
    UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", self.playerOneName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:setTitleAlert animated:YES completion:nil];
    }
    
    if (self.playerTwoStepper.value == 11){
        UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", self.playerTwoName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
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
