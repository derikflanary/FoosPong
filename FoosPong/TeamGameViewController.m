//
//  TeamGameViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/27/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "TeamGameViewController.h"
#import "ChoosePlayersViewController.h"
#import "SingleGameController.h"
#import "TeamGameDetails.h"
#import "TeamGameController.h"

#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <OpenEars/OEAcousticModel.h>
#import <OpenEars/OEEventsObserver.h>

@interface TeamGameViewController () <OEEventsObserverDelegate>

@property (nonatomic, assign) BOOL teamOneWin;
@property (nonatomic, assign) NSInteger teamOneScore;
@property (nonatomic, assign) NSInteger teamTwoScore;
@property (nonatomic, assign) NSInteger scoreToWin;
@property (nonatomic, strong) NSString *t1p1;
@property (nonatomic, strong) NSString *t1p2;
@property (nonatomic, strong) NSString *t2p1;
@property (nonatomic, strong) NSString *t2p2;
@property (nonatomic, strong) TeamGameDetails *gameStats;
@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;

@property (strong, nonatomic) FoosButton *team1PlusButton;
@property (strong, nonatomic) FoosButton *team2PlusButton;
@property (strong, nonatomic) UILabel *team1ScoreLabel;
@property (strong, nonatomic) UILabel *team2ScoreLabel;
@property (strong, nonatomic) UILabel *team1Label;
@property (strong, nonatomic) UILabel *team1p2Label;
@property (strong, nonatomic) UILabel *team2Label;
@property (strong, nonatomic) UILabel *team2p2Label;
@property (strong, nonatomic) FoosButton *team1MinusButton;
@property (strong, nonatomic) FoosButton *team2MinusButton;

@end

@implementation TeamGameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor darkColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor transparentWhite]];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:view];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    PFUser *player = [self.teamOne objectAtIndex:0];
    self.t1p1 = player.username;
    player = [self.teamOne objectAtIndex:1];
    self.t1p2 = player.username;
    player = [self.teamTwo objectAtIndex:0];
    self.t2p1 = player.username;
    player = [self.teamTwo objectAtIndex:1];
    self.t2p2 = player.username;
    
    self.team1PlusButton = [[FoosButton alloc]initWithFrame:CGRectMake(30, 200, 100, 100)];
    [self.team1PlusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.team1PlusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.team1PlusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.team1PlusButton.backgroundColor = [UIColor darkColor];
    [self.team1PlusButton addTarget:self action:@selector(team1PlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.team1PlusButton.layer.cornerRadius = 50;
    self.team1PlusButton.clipsToBounds = YES;
    
    self.team2PlusButton = [[FoosButton alloc]initWithFrame:CGRectMake(180, 200, 100, 100)];
    [self.team2PlusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.team2PlusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.team2PlusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.team2PlusButton.backgroundColor = [UIColor darkColor];
    [self.team2PlusButton addTarget:self action:@selector(team2PlusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.team2PlusButton.layer.cornerRadius = 50;
    self.team2PlusButton.clipsToBounds = YES;
    
    self.team1ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 100, 100)];
    self.team1ScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.team1ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:50];
    
    self.team2ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 100, 100, 100)];
    self.team2ScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.team2ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:50];
    
    self.team1Label = [[UILabel alloc]initWithFrame:CGRectMake(30, 425, 100, 50)];
    self.team1Label.text = [NSString stringWithFormat:@"Attacker:%@", self.t1p1];
    self.team1Label.textAlignment = NSTextAlignmentCenter;
    self.team1Label.font = [UIFont fontWithName:[NSString mainFont] size:12];
    
    self.team1p2Label = [[UILabel alloc]initWithFrame:CGRectMake(30, 475, 100, 50)];
    self.team1p2Label.text = [NSString stringWithFormat:@"Defender:%@", self.t1p2];
    self.team1p2Label.textAlignment = NSTextAlignmentCenter;
    self.team1p2Label.font = [UIFont fontWithName:[NSString mainFont] size:12];
    
    self.team2Label = [[UILabel alloc]initWithFrame:CGRectMake(180, 425, 100, 50)];
    self.team2Label.text = [NSString stringWithFormat:@"Attacker:%@", self.t2p1];
    self.team2Label.textAlignment = NSTextAlignmentCenter;
    self.team2Label.font = [UIFont fontWithName:[NSString mainFont] size:12];
    
    self.team2p2Label = [[UILabel alloc]initWithFrame:CGRectMake(180, 475, 100, 50)];
    self.team2p2Label.text = [NSString stringWithFormat:@"Defender:%@", self.t2p2];
    self.team2p2Label.textAlignment = NSTextAlignmentCenter;
    self.team2p2Label.font = [UIFont fontWithName:[NSString mainFont] size:12];

    
    self.team1MinusButton = [[FoosButton alloc]initWithFrame:CGRectMake(45, 350, 50, 50)];
    [self.team1MinusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [self.team1MinusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.team1MinusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.team1MinusButton.backgroundColor = [UIColor darkColor];
    [self.team1MinusButton addTarget:self action:@selector(team1MinusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.team1MinusButton.layer.cornerRadius = 25;
    self.team1MinusButton.clipsToBounds = YES;
    
    self.team2MinusButton = [[FoosButton alloc]initWithFrame:CGRectMake(215, 350, 50, 50)];
    [self.team2MinusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [self.team2MinusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.team2MinusButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:40];
    self.team2MinusButton.backgroundColor = [UIColor darkColor];
    [self.team2MinusButton addTarget:self action:@selector(team2MinusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.team2MinusButton.layer.cornerRadius = 25;
    self.team2MinusButton.clipsToBounds = YES;

    
    [self.view addSubview:self.team1Label];
    [self.view addSubview:self.team1ScoreLabel];
    [self.view addSubview:self.team1PlusButton];
    [self.view addSubview:self.team2Label];
    [self.view addSubview:self.team1p2Label];
    [self.view addSubview:self.team2p2Label];
    [self.view addSubview:self.team2ScoreLabel];
    [self.view addSubview:self.team2PlusButton];
    [self.view addSubview:self.team1MinusButton];
    [self.view addSubview:self.team2MinusButton];

    self.scoreToWin = 10;
    self.teamOneScore = 0;
    self.teamTwoScore = 0;
    self.team1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamOneScore];
    self.team2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamTwoScore];
    
    NSNumber *micOff = [[NSUserDefaults standardUserDefaults]objectForKey:@"micOff"];
    BOOL microphoneOff = micOff.boolValue;
    if (!microphoneOff) {

         self.navigationController.navigationBar.topItem.prompt = @"Voice Scoring Commands Activated";
        
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
            
            [OEPocketsphinxController sharedInstance].secondsOfSilenceToDetect = .4;
            [OEPocketsphinxController sharedInstance].vadThreshold = 3;
            [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
            [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
            
        }
    }

}

- (void)team1PlusButtonPressed:(id)sender{
    
    if (self.teamOneScore < (self.scoreToWin - 1)) {
        self.teamOneScore ++;
        self.team1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamOneScore];
        
    }else{
        self.teamOneScore = self.scoreToWin;
        self.team1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamOneScore];
        self.teamOneWin = YES;
        [[OEPocketsphinxController sharedInstance]stopListening];
        
        [self updateTeamGameStats];
        
        UIAlertController *winnerAlert = [UIAlertController alertControllerWithTitle:@"Team One Wins!" message:@"End Game?" preferredStyle:UIAlertControllerStyleAlert];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[TeamGameController sharedInstance] addGameWithTeamGameStats:self.gameStats];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
           
        }]];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self team1MinusButtonPressed:self];
        }]];
        [self presentViewController:winnerAlert animated:YES completion:nil];
    }
}

- (void)team2PlusButtonPressed:(id)sender{
    
    if (self.teamTwoScore < (self.scoreToWin - 1)) {
        self.teamTwoScore ++;
        self.team2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamTwoScore];
        
    }else{
        self.teamTwoScore = self.scoreToWin;
        self.team2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamTwoScore];
        self.teamOneWin = NO;
        [[OEPocketsphinxController sharedInstance]stopListening];
        
        [self updateTeamGameStats];
        
        UIAlertController *winnerAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Team Two Wins!"] message:@"End Game?" preferredStyle:UIAlertControllerStyleAlert];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[TeamGameController sharedInstance] addGameWithTeamGameStats:self.gameStats];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        }]];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self team2MinusButtonPressed:self];
        }]];

        [self presentViewController:winnerAlert animated:YES completion:nil];
    }
}

- (void)team1MinusButtonPressed:(id)sender{
    if (self.teamOneScore > 0) {
        self.teamOneScore --;
        self.team1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamOneScore];
    }
    
}

- (void)team2MinusButtonPressed:(id)sender{
    if (self.teamTwoScore > 0) {
        self.teamTwoScore --;
        self.team2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamTwoScore];
    }
    
}

- (void)updateTeamGameStats{
    
    self.gameStats = [TeamGameDetails new];
    self.gameStats.teamOneAttacker = [self.teamOne objectAtIndex:0];
    self.gameStats.teamOneDefender = [self.teamOne objectAtIndex:1];
    self.gameStats.teamTwoAttacker = [self.teamTwo objectAtIndex:0];
    self.gameStats.teamTwoDefender = [self.teamTwo objectAtIndex:1];
    self.gameStats.teamOneScore = self.teamOneScore;
    self.gameStats.teamTwoScore = self.teamTwoScore;
    self.gameStats.teamOneWin = [NSNumber numberWithBool:self.teamOneWin];
    self.gameStats.group = [PFUser currentUser][@"currentGroup"];
}


#pragma mark - Voice Commands

- (void) pocketsphinxFailedNoMicPermissions{
    
}
/** The user prompt to get mic permissions, or a check of the mic permissions, has completed with a TRUE or a FALSE result  (will only be returned on iOS7 or later).*/
- (void) micPermissionCheckCompleted:(BOOL)result{
    
    if (result){
        
        OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
        
        NSArray *words = @[@"TEAM ONE GOAL", @"TEAM TWO GOAL"];
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
         
        }else{
            [OEPocketsphinxController sharedInstance].secondsOfSilenceToDetect = .4;
            [OEPocketsphinxController sharedInstance].vadThreshold = 3;
            [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
            [[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
                    }
    }
}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
    if ([hypothesis isEqualToString:@"PLAYER ONE GOAL"]) {
        [self team1PlusButtonPressed:self];
    }else if ([hypothesis isEqualToString:@"PLAYER TWO GOAL"]){
        [self team2PlusButtonPressed:self];
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



- (void)cancelPressed:(id)sender{
    [[OEPocketsphinxController sharedInstance]stopListening];
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
