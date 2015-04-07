//
//  GameDetailViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/21/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GameDetailViewController.h"
#import "JTNumberScrollAnimatedView.h"

@interface GameDetailViewController ()

@property (nonatomic, strong) UILabel *p1NameLabel;
@property (nonatomic, strong) UILabel *p2NameLabel;
@property (nonatomic, strong) UILabel *p1ScoreLabel;
@property (nonatomic, strong) UILabel *p2ScoreLabel;
@property (nonatomic, strong) UILabel *p1RankNameLabel;
@property (nonatomic, strong) UILabel *p2RankNameLabel;
@property (nonatomic, strong) JTNumberScrollAnimatedView *p1Rank;
@property (nonatomic, strong) JTNumberScrollAnimatedView *p2Rank;
@property (nonatomic, strong) UILabel *p1RankChangeLabel;
@property (nonatomic, strong) UILabel *p2RankChangeLabel;
@property (nonatomic, strong) UILabel *team1Label;
@property (nonatomic, strong) UILabel *team2Label;

@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor mainWhite]];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    // self.view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredEffectView setFrame:self.view.bounds];
    
    [self.view addSubview:bluredEffectView];
    
    //Vibrancy Effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.view.bounds];
    
    // Add Vibrancy View to Blur View
    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    // Do any additional setup after loading the view.
    self.p1NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 100, 30)];
    self.p1NameLabel.font = [UIFont fontWithName:[NSString mainFont] size:20];
    self.p1NameLabel.textColor = [UIColor mint];
    self.p1NameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.p2NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 50, 100, 30)];
    self.p2NameLabel.font = [UIFont fontWithName:[NSString mainFont] size:20];
    self.p2NameLabel.textColor = [UIColor mint];
    self.p2NameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.team1Label = [[UILabel alloc]initWithFrame:CGRectMake(200, 50, 100, 30)];
    self.team1Label.font = [UIFont fontWithName:[NSString mainFont] size:20];
    self.team1Label.textColor = [UIColor mint];
    self.team1Label.textAlignment = NSTextAlignmentCenter;

    self.team2Label = [[UILabel alloc]initWithFrame:CGRectMake(200, 50, 100, 30)];
    self.team2Label.font = [UIFont fontWithName:[NSString mainFont] size:20];
    self.team2Label.textColor = [UIColor mint];
    self.team2Label.textAlignment = NSTextAlignmentCenter;

    self.p1ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 50, 50)];
    self.p1ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:40];
    self.p1ScoreLabel.textColor = [UIColor indianYellow];
    self.p1ScoreLabel.textAlignment = NSTextAlignmentCenter;
    
    self.p2ScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 100, 50, 50)];
    self.p2ScoreLabel.font = [UIFont fontWithName:[NSString mainFont] size:40];
    self.p2ScoreLabel.textColor = [UIColor indianYellow];
    self.p2ScoreLabel.textAlignment = NSTextAlignmentCenter;
    
    self.p1RankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 100, 30)];
    self.p1RankNameLabel.font = [UIFont fontWithName:[NSString mainFont] size:24];
    self.p1RankNameLabel.textColor = [UIColor mint];
    self.p1RankNameLabel.text = @"Rank";
    self.p1RankNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.p2RankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 200, 100, 30)];
    self.p2RankNameLabel.font = [UIFont fontWithName:[NSString mainFont] size:24];
    self.p2RankNameLabel.textColor = [UIColor mint];
    self.p2RankNameLabel.text = @"Rank";
    self.p2RankNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.p1Rank = [[JTNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(20, 250, 100, 50)];
    self.p1Rank.textColor = [UIColor lightTextColor];
    self.p1Rank.font = [UIFont fontWithName:@"GillSans-Bold" size:28];
    
    self.p2Rank = [[JTNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(180, 250, 100, 50)];
    self.p2Rank.textColor = [UIColor lightTextColor];
    self.p2Rank.font = [UIFont fontWithName:@"GillSans-Bold" size:28];
   
    self.p1RankChangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 240, 50, 21)];
    self.p1RankChangeLabel.textColor = [UIColor lunarGreen];
    self.p1RankChangeLabel.font = [UIFont fontWithName:[NSString mainFont] size:16];
    
    self.p2RankChangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 240, 50, 21)];
    self.p2RankChangeLabel.textColor = [UIColor lunarGreen];
    self.p2RankChangeLabel.font = [UIFont fontWithName:[NSString mainFont] size:16];
    
    if (self.singleGame) {
        self.p1NameLabel.text = [self.singleGame.p1.username uppercaseString];
        self.p2NameLabel.text = [self.singleGame.p2.username uppercaseString];
        self.p1ScoreLabel.text = [NSString stringWithFormat:@"%.f", self.singleGame.playerOneScore];
        self.p2ScoreLabel.text = [NSString stringWithFormat:@"%.f", self.singleGame.playerTwoScore];
        [self.p1Rank setValue:self.singleGame.playerOneNewRank];
        [self.p2Rank setValue:self.singleGame.playerTwoNewRank];
        
        NSInteger diff1 = [self.singleGame.playerOneNewRank integerValue] - [self.singleGame.playerOneStartingRank integerValue];
        self.p1RankChangeLabel.text = [NSString stringWithFormat:@"%+ld", (long)diff1];
        
        NSInteger diff2 = [self.singleGame.playerTwoNewRank integerValue] - [self.singleGame.playerTwoStartingRank integerValue];
        self.p2RankChangeLabel.text = [NSString stringWithFormat:@"%+ld", (long)diff2];
    }else{
        self.p1NameLabel.text = [self.teamGame.teamOneDefender.username uppercaseString];
        self.p2NameLabel.text = [self.teamGame.teamTwoDefender.username uppercaseString];
        self.team1Label.text = [self.teamGame.teamOneAttacker.username uppercaseString];
        self.team2Label.text = [self.teamGame.teamTwoAttacker.username uppercaseString];
        self.p1ScoreLabel.text = [NSString stringWithFormat:@"%.f", self.teamGame.teamOneScore];
        self.p2ScoreLabel.text = [NSString stringWithFormat:@"%.f", self.teamGame.teamTwoScore];
        [self.p1Rank setValue:self.teamGame.teamOneAttackerNewRank];
        [self.p2Rank setValue:self.teamGame.teamTwoAttackerNewRank];
    }
    
    
    
    
    [vibrancyEffectView addSubview:self.p1NameLabel];
    [vibrancyEffectView addSubview:self.p2NameLabel];
    [vibrancyEffectView addSubview:self.p1ScoreLabel];
    [vibrancyEffectView addSubview:self.p2ScoreLabel];
    [vibrancyEffectView addSubview:self.p1RankNameLabel];
    [vibrancyEffectView addSubview:self.p2RankNameLabel];
    [vibrancyEffectView addSubview:self.p1Rank];
    [vibrancyEffectView addSubview:self.p2Rank];
    [vibrancyEffectView addSubview:self.p1RankChangeLabel];
    [vibrancyEffectView addSubview:self.p2RankChangeLabel];
    [vibrancyEffectView addSubview:self.team1Label];
    [vibrancyEffectView addSubview:self.team2Label];

    [self.p1Rank startAnimation];
    [self.p2Rank startAnimation];

//autoLayout
    
    self.p1NameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2NameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p1ScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2ScoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.p1RankNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2RankNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p1Rank.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2Rank.translatesAutoresizingMaskIntoConstraints = NO;
    self.p1RankChangeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.p2RankChangeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.team1Label.translatesAutoresizingMaskIntoConstraints = NO;
    self.team2Label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_p1NameLabel, _p2NameLabel, _p1ScoreLabel, _p2ScoreLabel, _p1RankNameLabel, _p2RankNameLabel, _p1Rank, _p2Rank, _p1RankChangeLabel, _p2RankChangeLabel, _team1Label, _team2Label);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==10)-[_p1NameLabel(>=130)]-(>=8)-[_p2NameLabel(>=130)]-(==10)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==10)-[_p1Rank(==130)]-(>=8)-[_p2Rank(==130)]-(==10)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    [self.view addConstraints:constraints];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_team1Label(==31)]-[_p1NameLabel(==31)]-[_p1ScoreLabel(>=50)]-(==50)-[_p1RankNameLabel(==31)]-[_p1Rank(==50)]-[_p1RankChangeLabel(==21)]-(>=75)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_team2Label(==31)]-[_p2NameLabel(==31)]-[_p2ScoreLabel(>=50)]-(==50)-[_p2RankNameLabel(==31)]-[_p2Rank(==50)]-[_p2RankChangeLabel(==21)]-(>=75)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];
    
    
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==100)-[_p2ScoreLabel(>=100)]-[_p2PlusButton]-(==50)-[_p2MinusButton(==50)]-(==50)-[_p2Label]-(==50)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewsDictionary]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{

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
