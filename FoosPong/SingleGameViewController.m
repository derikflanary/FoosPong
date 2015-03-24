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

#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>
#import <OpenEars/OEEventsObserver.h>

static NSString * const playerOneKey = @"playerOneKey";
static NSString * const playerTwoKey = @"playerTwoKey";
static NSString * const playerOneScoreKey = @"playerOneScoreKey";
static NSString * const playerTwoScoreKey = @"playerTwoScoreKey";
static NSString * const playerOneWinKey = @"playerOneWinKey";
static NSString * const playerTwoWinKey = @"playerTwoWinKey";

@interface SingleGameViewController () <OEEventsObserverDelegate>

@property (nonatomic, assign) float scoreToWin;
@property (nonatomic, strong) PKYStepper *playerOneStepper;
@property (nonatomic, strong) PKYStepper *playerTwoStepper;
@property (nonatomic, assign) NSNumber *playerOneScore;
@property (nonatomic, assign) NSNumber *playerTwoScore;
@property (nonatomic, assign) BOOL playerOneWin;
@property (nonatomic, assign) BOOL playerTwoWin;
@property (nonatomic, strong) SingleGameStats *gameStats;

@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;


@end

@implementation SingleGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainBlack]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor transparentWhite]];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:view];
    
    self.scoreToWin = 10;
    self.playerOneWin = NO;
    self.playerTwoWin = NO;
    self.playerOneName = self.playerOne.username;
    self.playerTwoName = self.playerTwo.username;
    
//    UIBarButtonItem * saveGameButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveGamePressed:)];
    //self.navigationItem.rightBarButtonItem = saveGameButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    __block SingleGameViewController *bSelf = self;
    self.playerOneStepper = [[PKYStepper alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];

    self.playerOneStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        stepper.countLabel.text = [NSString stringWithFormat:@"%@: %@",bSelf.playerOneName, @(count)];
    };
    [self.playerOneStepper setup];
    self.playerOneStepper.maximum = self.scoreToWin;
    [self.playerOneStepper setBorderColor:[UIColor clearColor]];
    [self.playerOneStepper setBorderWidth:0];
    //[self.playerOneStepper setLabelColor:[UIColor mainColorTransparent]];
    [self.playerOneStepper setLabelFont:[UIFont fontWithName:[NSString mainFont] size:22]];
    [self.playerOneStepper setLabelTextColor:[UIColor transparentCellBlack]];
    self.playerOneStepper.backgroundColor = [UIColor clearColor];
    [self.playerOneStepper setButtonTextColor:[UIColor mainBlack] forState:UIControlStateNormal];
    [self.playerOneStepper setButtonTextColor:[UIColor transparentCellBlack] forState:UIControlStateHighlighted];
    [self.playerOneStepper.incrementButton setImage:[UIImage imageNamed:@"68"] forState:UIControlStateNormal];
    [self.playerOneStepper.incrementButton setImage:[UIImage imageNamed:@"58"] forState:UIControlStateHighlighted];
    [self.playerOneStepper.decrementButton setImage:[UIImage imageNamed:@"69"] forState:UIControlStateNormal];
    self.playerOneStepper.buttonWidth = 75;
    
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
    
    
    
//VOICE RECOGNITION
    
    OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
    
    NSArray *words = @[@"PLAYER ONE GOAL", @"PLAYER TWO GOAL"];
    NSString *name = @"LanguageFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]];
    NSString *lmPath = nil;
    NSString *dicPath = nil;
    
    if(err == nil) {
        
        lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"LanguageFiles"];
        dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"LanguageFiles"];
        
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
    self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
    [self.openEarsEventsObserver setDelegate:self];
    
    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
    [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
    
}

#pragma mark - Voice Commands

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
}

- (void) pocketsphinxDidStartListening {
    NSLog(@"Pocketsphinx is now listening.");
    
}

- (void) pocketsphinxDidDetectSpeech {
    NSLog(@"Pocketsphinx has detected speech.");
    
}

- (void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
    
}

- (void) pocketsphinxDidStopListening {
    NSLog(@"Pocketsphinx has stopped listening.");
    
}

- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pocketsphinx has suspended recognition.");
    
}

- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pocketsphinx has resumed recognition.");
    
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
    NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
    
}

- (void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening setup wasn't successful and returned the failure reason: %@", reasonForFailure);
    
}

- (void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure {
    NSLog(@"Listening teardown wasn't successful and returned the failure reason: %@", reasonForFailure);
    
}

- (void) testRecognitionCompleted {
    NSLog(@"A test file that was submitted for recognition is now complete.");
    
}



#pragma mark - Tracking Scores



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

#pragma mark - Other Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
