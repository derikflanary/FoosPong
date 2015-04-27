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
#import "GameDetailViewController.h"

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
@property (nonatomic, assign) BOOL tenPointGameOn;

@end

@implementation TeamGameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor golderBrown]];

//    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
//    background.frame = self.view.frame;
//    background.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:background];
    
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor darkColor];
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
    self.team1ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:80];
    self.team1ScoreLabel.textColor = [UIColor mainWhite];
    
    self.team2ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 100, 100, 100)];
    self.team2ScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.team2ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:80];
    self.team2ScoreLabel.textColor = [UIColor mainWhite];
    
    self.team1Label = [[UILabel alloc]initWithFrame:CGRectMake(30, 425, 100, 50)];
    self.team1Label.text = [NSString stringWithFormat:@"Attacker:%@", [self.t1p1 uppercaseString] ];
    self.team1Label.textAlignment = NSTextAlignmentCenter;
    self.team1Label.font = [UIFont fontWithName:[NSString mainFont] size:18];
    self.team1Label.textColor = [UIColor mainWhite];
    
    self.team1p2Label = [[UILabel alloc]initWithFrame:CGRectMake(30, 475, 100, 50)];
    self.team1p2Label.text = [NSString stringWithFormat:@"Defender:%@", [self.t1p2 uppercaseString]];
    self.team1p2Label.textAlignment = NSTextAlignmentCenter;
    self.team1p2Label.font = [UIFont fontWithName:[NSString mainFont] size:18];
    self.team1p2Label.textColor = [UIColor mainWhite];
    
    self.team2Label = [[UILabel alloc]initWithFrame:CGRectMake(180, 425, 100, 50)];
    self.team2Label.text = [NSString stringWithFormat:@"Attacker:%@", [self.t2p1 uppercaseString]];
    self.team2Label.textAlignment = NSTextAlignmentCenter;
    self.team2Label.font = [UIFont fontWithName:[NSString mainFont] size:18];
    self.team2Label.textColor = [UIColor mainWhite];
    
    self.team2p2Label = [[UILabel alloc]initWithFrame:CGRectMake(180, 475, 100, 50)];
    self.team2p2Label.text = [NSString stringWithFormat:@"Defender:%@", [self.t2p2 uppercaseString]];
    self.team2p2Label.textAlignment = NSTextAlignmentCenter;
    self.team2p2Label.font = [UIFont fontWithName:[NSString mainFont] size:18];
    self.team2p2Label.textColor = [UIColor mainWhite];
    
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
    
    NSNumber *tenPointGame = [[NSUserDefaults standardUserDefaults]objectForKey:@"tenPointGamesOn"];
    self.tenPointGameOn = tenPointGame.boolValue;
    
    if (self.tenPointGameOn) {
        self.scoreToWin = 10;
    }else{
        self.scoreToWin = 5;
    }

    self.teamOneScore = 0;
    self.teamTwoScore = 0;
    self.team1ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamOneScore];
    self.team2ScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.teamTwoScore];
    
    NSNumber *micOff = [[NSUserDefaults standardUserDefaults]objectForKey:@"micOff"];
    BOOL microphoneOff = micOff.boolValue;
    if (!microphoneOff) {

         self.navigationController.navigationBar.topItem.prompt = @"Voice Scoring Commands Activated";
        
        OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
        
        NSArray *words = @[@"ONE GOAL", @"TWO GOAL"];
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

    
    
    self.team1ScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.team1PlusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.team1MinusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.team1Label.translatesAutoresizingMaskIntoConstraints = NO;
    self.team1p2Label.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.team2ScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.team2PlusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.team2MinusButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.team2Label.translatesAutoresizingMaskIntoConstraints = NO;
    self.team2p2Label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_team1PlusButton, _team2PlusButton, _team1ScoreLabel, _team1MinusButton, _team1Label, _team2ScoreLabel, _team2MinusButton, _team2Label, _team1p2Label, _team2p2Label);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_team1PlusButton(>=100)]-(>=8)-[_team2PlusButton(>=100)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=8)-[_team1MinusButton(==50)]-(>=8)-[_team2MinusButton(==50)]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=8)-[_team1Label(>=100)]-(>=8)-[_team2Label(>=100)]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=8)-[_team1p2Label(>=100)]-(>=8)-[_team2p2Label(>=100)]-(>=8)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_team1ScoreLabel(>=100)]-[_team1PlusButton]-(==50)-[_team1MinusButton(==50)]-(==50)-[_team1Label]-(==10)-[_team1p2Label]-(>=30)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_team2ScoreLabel(>=100)]-[_team2PlusButton]-(==50)-[_team2MinusButton(==50)]-(==50)-[_team2Label]-(==10)-[_team2p2Label]-(>=30)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];

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
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self team1MinusButtonPressed:self];
        }]];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[TeamGameController sharedInstance] addGameWithTeamGameStats:self.gameStats callback:^(TeamGameDetails *theGameStats) {
                GameDetailViewController *gdvc = [GameDetailViewController new];
                gdvc.teamGame = self.gameStats;
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gdvc];
                
                navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                
                [self.navigationController presentViewController:navController animated:YES completion:^{
                    
                }];
                
            }];
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
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self team2MinusButtonPressed:self];
        }]];
        
        [winnerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[TeamGameController sharedInstance] addGameWithTeamGameStats:self.gameStats callback:^(TeamGameDetails *theGameStats) {
                GameDetailViewController *gdvc = [GameDetailViewController new];
                gdvc.teamGame = self.gameStats;
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gdvc];
                
                navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                
                [self.navigationController presentViewController:navController animated:YES completion:^{
                    
                }];

            }];
            
            
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
    self.gameStats.teamOneWin = self.teamOneWin;
    self.gameStats.group = [PFUser currentUser][@"currentGroup"];
    self.gameStats.teamOneAttackerStartingRank = self.teamOneAttackerRank;
    self.gameStats.teamOneDefenderStartingRank = self.teamOneDefenderRank;
    self.gameStats.teamTwoAttackerStartingRank = self.teamTwoAttackerRank;
    self.gameStats.teamTwoDefenderStartingRank = self.teamTwoDefenderRank;
    self.gameStats.isGuestGame = self.isGuestGame;
    
    if (self.tenPointGameOn) {
        self.gameStats.tenPointGame = YES;
    }else{
        self.gameStats.tenPointGame = NO;
    }
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
