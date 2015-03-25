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

@property (nonatomic, assign) NSInteger scoreToWin;
@property (nonatomic, strong) PKYStepper *playerOneStepper;
@property (nonatomic, strong) PKYStepper *playerTwoStepper;
@property (nonatomic, assign) NSInteger playerOneScore;
@property (nonatomic, assign) NSInteger playerTwoScore;
@property (nonatomic, assign) BOOL playerOneWin;
@property (nonatomic, assign) BOOL playerTwoWin;
@property (nonatomic, strong) SingleGameStats *gameStats;
@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;

@property (strong, nonatomic) UIButton *p1PlusButton;
@property (strong, nonatomic) UIButton *p2PlusButton;
@property (strong, nonatomic) UILabel *p1ScoreLabel;
@property (strong, nonatomic) UILabel *p2ScoreLabel;
@property (strong, nonatomic) UILabel *p1Label;
@property (strong, nonatomic) UILabel *p2Label;



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
    
    self.p1PlusButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 100, 100)];
    [self.p1PlusButton setTitle:@"+" forState:UIControlStateNormal];
    [self.p1PlusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.p1PlusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.p1PlusButton.backgroundColor = [UIColor darkColor];
    [self.p1PlusButton addTarget:self action:@selector(p1PlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.p1PlusButton.layer.cornerRadius = 50;
    self.p1PlusButton.clipsToBounds = YES;
    
    self.p2PlusButton = [[UIButton alloc]initWithFrame:CGRectMake(180, 200, 100, 100)];
    [self.p2PlusButton setTitle:@"+" forState:UIControlStateNormal];
    [self.p2PlusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.p2PlusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.p2PlusButton.backgroundColor = [UIColor darkColor];
    [self.p2PlusButton addTarget:self action:@selector(p2PlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.p2PlusButton.layer.cornerRadius = 50;
    self.p2PlusButton.clipsToBounds = YES;

    self.p1ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 100, 100)];
    self.p1ScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.p1ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:50];
    
    self.p2ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 100, 100, 100)];
    self.p2ScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.p2ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:50];
    
    self.p1Label = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 100, 50)];
    self.p1Label.text = self.playerOneName;
    self.p1Label.textAlignment = NSTextAlignmentCenter;
    self.p1Label.font = [UIFont fontWithName:[NSString mainFont] size:18];
    
    self.p2Label = [[UILabel alloc]initWithFrame:CGRectMake(180, 60, 100, 50)];
    self.p2Label.text = self.playerTwoName;
    self.p2Label.textAlignment = NSTextAlignmentCenter;
    self.p2Label.font = [UIFont fontWithName:[NSString mainFont] size:18];

    [self.view addSubview:self.p1Label];
    [self.view addSubview:self.p1PlusButton];
    [self.view addSubview:self.p1ScoreLabel];
    [self.view addSubview:self.p2PlusButton];
    [self.view addSubview:self.p2ScoreLabel];
    [self.view addSubview:self.p2Label];
    
    self.playerOneScore = 0;
    self.playerTwoScore = 0;
    self.p1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerOneScore];
    self.p2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerTwoScore];
    
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
    
    if ([[OEPocketsphinxController sharedInstance]micPermissionIsGranted]) {
        [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
        [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
    }
    
}

- (void)p1PlusButtonPressed:(id)sender{
    
    if (self.playerOneScore < (self.scoreToWin - 1)) {
        self.playerOneScore ++;
        self.p1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerOneScore];
        
    }else{
        self.playerOneScore = self.scoreToWin;
        self.p1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerOneScore];
        self.playerOneWin = YES;
        
        [[OEPocketsphinxController sharedInstance]stopListening];
        [self updateGameStats];
        
        UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", self.playerOneName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"End Game" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [[SingleGameController sharedInstance] addGameWithSingleGameStats:self.gameStats];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }]];
        [self presentViewController:setTitleAlert animated:YES completion:nil];
    }
}

- (void)p2PlusButtonPressed:(id)sender{
    
    if (self.playerTwoScore < (self.scoreToWin - 1)) {
        self.playerTwoScore ++;
        self.p2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerTwoScore];
    }else{
        self.playerTwoScore = self.scoreToWin;
        self.p2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerTwoScore];
        self.playerTwoWin = YES;
        
        [[OEPocketsphinxController sharedInstance]stopListening];
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

#pragma mark - Voice Commands

- (void) pocketsphinxFailedNoMicPermissions{
    
}
/** The user prompt to get mic permissions, or a check of the mic permissions, has completed with a TRUE or a FALSE result  (will only be returned on iOS7 or later).*/
- (void) micPermissionCheckCompleted:(BOOL)result{
    
    if (result){
                
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
        
    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
    [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
   }
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
    if ([hypothesis isEqualToString:@"PLAYER ONE GOAL"]) {
        [self p1PlusButtonPressed:self];
    }else if ([hypothesis isEqualToString:@"PLAYER TWO GOAL"]){
        [self p2PlusButtonPressed:self];
    }
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
