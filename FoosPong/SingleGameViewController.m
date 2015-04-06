//
//  GameViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/9/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SingleGameViewController.h"
#import "ChoosePlayersViewController.h"
#import "SingleGameController.h"
#import "SingleGameDetails.h"
#import "MinusButton.h"
#import "GameDetailViewController.h"

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
@property (nonatomic, assign) NSInteger playerOneScore;
@property (nonatomic, assign) NSInteger playerTwoScore;
@property (nonatomic, assign) BOOL playerOneWin;
@property (nonatomic, assign) BOOL playerTwoWin;
@property (nonatomic, strong) SingleGameDetails *gameStats;
@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;

@property (strong, nonatomic) FoosButton *p1PlusButton;
@property (strong, nonatomic) FoosButton *p2PlusButton;
@property (strong, nonatomic) UILabel *p1ScoreLabel;
@property (strong, nonatomic) UILabel *p2ScoreLabel;
@property (strong, nonatomic) UILabel *p1Label;
@property (strong, nonatomic) UILabel *p2Label;
@property (strong, nonatomic) MinusButton *p1MinusButton;
@property (strong, nonatomic) MinusButton *p2MinusButton;



@end

@implementation SingleGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainWhite]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor golderBrown]];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:background];
    
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor darkColor];
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
    
    self.p1PlusButton = [[FoosButton alloc]initWithFrame:CGRectMake(30, 200, 100, 100)];
    [self.p1PlusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.p1PlusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.p1PlusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.p1PlusButton.backgroundColor = [UIColor darkColor];
    [self.p1PlusButton addTarget:self action:@selector(p1PlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.p1PlusButton.layer.cornerRadius = 50;
    self.p1PlusButton.clipsToBounds = YES;
    
    self.p2PlusButton = [[FoosButton alloc]initWithFrame:CGRectMake(180, 200, 100, 100)];
    [self.p2PlusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.p2PlusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.p2PlusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.p2PlusButton.backgroundColor = [UIColor darkColor];
    [self.p2PlusButton addTarget:self action:@selector(p2PlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.p2PlusButton.layer.cornerRadius = 50;
    self.p2PlusButton.clipsToBounds = YES;

    self.p1ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 100, 100)];
    self.p1ScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.p1ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:80];
    self.p1ScoreLabel.textColor = [UIColor mainWhite];
//    self.p1ScoreLabel.layer.borderColor = [UIColor golderBrown].CGColor;
//    self.p1ScoreLabel.layer.borderWidth = 1.0f;
    
    self.p2ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 100, 100, 100)];
    self.p2ScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.p2ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:80];
    self.p2ScoreLabel.textColor = [UIColor mainWhite];
//    self.p2ScoreLabel.layer.borderColor = [UIColor golderBrown].CGColor;
//    self.p2ScoreLabel.layer.borderWidth = 1.0f;
    
    self.p1Label = [[UILabel alloc]initWithFrame:CGRectMake(30, 425, 100, 50)];
    self.p1Label.text = [self.playerOneName uppercaseString];
    self.p1Label.textAlignment = NSTextAlignmentCenter;
    self.p1Label.font = [UIFont fontWithName:[NSString mainFont] size:16];
    self.p1Label.textColor = [UIColor mainWhite];
    
    self.p2Label = [[UILabel alloc]initWithFrame:CGRectMake(180, 425, 100, 50)];
    self.p2Label.text = [self.playerTwoName uppercaseString];
    self.p2Label.textAlignment = NSTextAlignmentCenter;
    self.p2Label.font = [UIFont fontWithName:[NSString mainFont] size:16];
    self.p2Label.textColor = [UIColor mainWhite];
    
    self.p1MinusButton = [[MinusButton alloc]initWithFrame:CGRectMake(45, 350, 50, 50)];
    [self.p1MinusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [self.p1MinusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.p1MinusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.p1MinusButton.backgroundColor = [UIColor darkColor];
    [self.p1MinusButton addTarget:self action:@selector(p1MinusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.p1MinusButton.layer.cornerRadius = 25;
    self.p1MinusButton.clipsToBounds = YES;
    
    self.p2MinusButton = [[MinusButton alloc]initWithFrame:CGRectMake(215, 350, 50, 50)];
    [self.p2MinusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [self.p2MinusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.p2MinusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.p2MinusButton.backgroundColor = [UIColor darkColor];
    [self.p2MinusButton addTarget:self action:@selector(p2MinusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.p2MinusButton.layer.cornerRadius = 25;
    self.p2MinusButton.clipsToBounds = YES;

    [self.view addSubview:self.p1Label];
    [self.view addSubview:self.p1PlusButton];
    [self.view addSubview:self.p1ScoreLabel];
    [self.view addSubview:self.p2PlusButton];
    [self.view addSubview:self.p2ScoreLabel];
    [self.view addSubview:self.p2Label];
    [self.view addSubview:self.p1MinusButton];
    [self.view addSubview:self.p2MinusButton];
    
    self.playerOneScore = 0;
    self.playerTwoScore = 0;
    self.p1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerOneScore];
    self.p2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerTwoScore];
    
//VOICE RECOGNITION
    
    NSNumber *micOff = [[NSUserDefaults standardUserDefaults]objectForKey:@"micOff"];
    BOOL microphoneOff = micOff.boolValue;
    if (!microphoneOff) {
        
        self.navigationController.navigationBar.topItem.prompt = @"Voice Scoring Commands Active";

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
        
        if ([[OEPocketsphinxController sharedInstance]isListening]) {
            [[OEPocketsphinxController sharedInstance]stopListening];
        }
        
        if ([[OEPocketsphinxController sharedInstance]micPermissionIsGranted]) {
            [OEPocketsphinxController sharedInstance].secondsOfSilenceToDetect = .5;
            [OEPocketsphinxController sharedInstance].vadThreshold = 3;
            
            [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
            [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
            
        }
        
 
    }
    
//AutoLayout
    
    self.p1ScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p1PlusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.p1MinusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.p1Label.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.p2ScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2PlusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2MinusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2Label.translatesAutoresizingMaskIntoConstraints = NO;

    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_p1PlusButton, _p2PlusButton, _p1ScoreLabel, _p1MinusButton, _p1Label, _p2ScoreLabel, _p2MinusButton, _p2Label);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_p1PlusButton(>=100)]-(>=8)-[_p2PlusButton(>=100)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=8)-[_p1MinusButton(==50)]-(>=8)-[_p2MinusButton(==50)]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    [self.view addConstraints:constraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_p1ScoreLabel(>=100)]-[_p1PlusButton]-(==50)-[_p1MinusButton(==50)]-(==50)-[_p1Label]-(==50)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_p2ScoreLabel(>=100)]-[_p2PlusButton]-(==50)-[_p2MinusButton(==50)]-(==50)-[_p2Label]-(==50)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    
//    NSLayoutConstraint *centerConstraint =
//    [NSLayoutConstraint constraintWithItem:self.scoreField
//                                 attribute:NSLayoutAttributeCenterX
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:self.contentView
//                                 attribute:NSLayoutAttributeCenterX
//                                multiplier:1
//                                  constant:0];
//    centerConstraint.priority = UILayoutPriorityDefaultHigh;
//    [self.contentView addConstraint:centerConstraint];
//    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.photoButton
//                                                                 attribute:NSLayoutAttributeWidth
//                                                                 relatedBy:NSLayoutRelationEqual
//                                                                    toItem:self.photoButton
//                                                                 attribute:NSLayoutAttributeHeight
//                                                                multiplier:1
//                                                                  constant:0]];
    

    
}

#pragma mark - Tracking Scores

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
        
        UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", [self.playerOneName uppercaseString]] message:@"End Game?" preferredStyle:UIAlertControllerStyleAlert];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[SingleGameController sharedInstance] addGameWithSingleGameStats:self.gameStats callback:^(Game *singleGame) {
                
                    GameDetailViewController *gdvc = [GameDetailViewController new];
                    gdvc.singleGame = singleGame;
                    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gdvc];
                    
                    navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    
                    [self.navigationController presentViewController:navController animated:YES completion:^{
                    
                }];
            }];
            
        }]];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self p1MinusButtonPressed:self];
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
        
        UIAlertController *setTitleAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Wins!", [self.playerTwoName uppercaseString]] message:@"End Game?" preferredStyle:UIAlertControllerStyleAlert];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[SingleGameController sharedInstance] addGameWithSingleGameStats:self.gameStats callback:^(Game *singleGame) {
                
                GameDetailViewController *gdvc = [GameDetailViewController new];
                gdvc.singleGame = singleGame;
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gdvc];
                
                navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                
                [self.navigationController presentViewController:navController animated:YES completion:^{
                    
                }];
            }];

            
        }]];
        
        [setTitleAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self p2MinusButtonPressed:self];
        }]];
        [self presentViewController:setTitleAlert animated:YES completion:nil];
    }
}



- (void)p1MinusButtonPressed:(id)sender{
    if (self.playerOneScore > 0) {
        self.playerOneScore --;
        self.p1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerOneScore];
    }
    
}

- (void)p2MinusButtonPressed:(id)sender{
    if (self.playerTwoScore > 0) {
        self.playerTwoScore --;
        self.p2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.playerTwoScore];
    }
    
}

- (void)updateGameStats{
    
    self.gameStats = [SingleGameDetails new];
    self.gameStats.playerOne = self.playerOne;
    self.gameStats.playerTwo = self.playerTwo;
    self.gameStats.playerOneScore = self.playerOneScore;
    self.gameStats.playerTwoScore = self.playerTwoScore;
    self.gameStats.playerOneWin = self.playerOneWin;
    self.gameStats.group = [PFUser currentUser][@"currentGroup"];
    self.gameStats.playerOneStartingRank = self.playerOneRanking[@"rank"];
    self.gameStats.playerTwoStartingRank = self.playerTwoRanking[@"rank"];
}


#pragma mark - Other Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
    [[OEPocketsphinxController sharedInstance]stopListening];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)saveGamePressed:(id)sender{
    
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Save Game" message:@"Would you like to save this game for later?" preferredStyle:UIAlertControllerStyleAlert];
    
    [saveAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [saveAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:saveAlert animated:YES completion:nil];
    
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
        if ([[OEPocketsphinxController sharedInstance]isListening]) {
            
        }else {
            
            [OEPocketsphinxController sharedInstance].secondsOfSilenceToDetect = .5;
            [OEPocketsphinxController sharedInstance].vadThreshold = 3;
            
            [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
            [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
        }
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
    //    double delayInSeconds = 2.0; // number of seconds to wait
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //
    //    });
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
