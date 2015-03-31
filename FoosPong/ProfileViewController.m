//
//  ProfileViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/9/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+Letters.h"
#import "UserController.h"
#import "NSString+Extensions.h"
#import "SingleGameController.h"
#import "StatsController.h"
#import "PersonalSingleStats.h"
#import "TeamGameDetails.h"
#import "NewGameCustomTableViewCell.h"
#import "StatsViewController.h"
#import "UserController.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate,  UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *fullNameLabel;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UILabel *recordNameLabel;
@property (nonatomic, strong) UILabel *joinedLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *singleLabel;
@property (nonatomic, strong) UILabel *singleAmountLabel;
@property (nonatomic, strong) UILabel *doubleLabel;
@property (nonatomic, strong) UILabel *doubleAmountLabel;




@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray *singleGames;
@property (nonatomic, strong) NSArray *teamGames;
@property (nonatomic, strong) PersonalSingleStats *persoanlStats;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) FoosButton *statsButton;
@property (nonatomic, strong) UINavigationController *navController;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
//    background.frame = self.view.frame;
//    background.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:background];
    
    UIView *whiteWall = [[UIView alloc]initWithFrame:self.view.bounds];
    whiteWall.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:whiteWall];

    self.tabBarController.navigationItem.hidesBackButton = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.currentUser = [PFUser currentUser];
    
    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    
    
    // add the effect view to the image view
   
    
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 211)];
    self.headerImageView.image = [UIImage imageNamed:@"foos"];
    self.headerImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.headerImageView];
    effectView.frame = self.headerImageView.frame;
    [self.headerImageView addSubview:effectView];
    
    self.usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(117, 155, 176, 31)];
    self.usernameLabel.font = [UIFont fontWithName:[NSString mainFont] size:30];
    self.usernameLabel.textColor = [UIColor mainWhite];
    self.usernameLabel.text = [self.currentUser.username uppercaseString];
    [self.view addSubview:self.usernameLabel];
    
    self.fullNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(117, 188, 176, 21)];
    self.fullNameLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    self.fullNameLabel.textColor = [UIColor indianYellow];
    self.fullNameLabel.text = [NSString combineNames:self.currentUser[@"firstName"] and:self.currentUser[@"lastName"]];
    [self.view addSubview:self.fullNameLabel];
    
    
    
    UIView *holderView = [[UIView alloc]initWithFrame:CGRectMake(0, 265, self.view.frame.size.width, 47)];
    [self.view addSubview:holderView];
    
    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, holderView.frame.size.width, 1.0f);
    TopBorder.backgroundColor = [UIColor marigoldBrown].CGColor;
    
    
    self.recordNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 13, 158, 21)];
    self.recordNameLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:16];
    self.recordNameLabel.textColor = [UIColor darkColor];
    self.recordNameLabel.text = @"Overall Record:";
    [holderView addSubview:self.recordNameLabel];
    
    self.recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 13, 114, 21)];
    self.recordLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:20];
    self.recordLabel.textColor = [UIColor darkColor];
//    self.recordLabel.text = @"8 - 4";
    [holderView addSubview:self.recordLabel];
    
    UIView *holderView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 314, self.view.frame.size.width, 47)];
    [self.view addSubview:holderView2];
    
    self.singleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 13, 158, 21)];
    self.singleLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:16];
    self.singleLabel.textColor = [UIColor darkColor];
    self.singleLabel.text = @"1v1 Games Played:";
    [holderView2 addSubview:self.singleLabel];
    
    self.singleAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 13, 114, 21)];
    self.singleAmountLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:20];
    self.singleAmountLabel.textColor = [UIColor darkColor];
    [holderView2 addSubview:self.singleAmountLabel];
    
    UIView *holderView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 361, self.view.frame.size.width, 47)];
    [self.view addSubview:holderView3];
    [holderView3.layer addSublayer:TopBorder];
    
    self.doubleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 13, 158, 21)];
    self.doubleLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:16];
    self.doubleLabel.textColor = [UIColor darkColor];
    self.doubleLabel.text = @"2v2 Games Played:";
    [holderView3 addSubview:self.doubleLabel];
    
    self.doubleAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 13, 114, 21)];
    self.doubleAmountLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:20];
    self.doubleAmountLabel.textColor = [UIColor darkColor];
    [holderView3 addSubview:self.doubleAmountLabel];

    
    CALayer *topBorder2 = [CALayer layer];
    topBorder2.frame = CGRectMake(0.0f, 0.0f, holderView.frame.size.width, 1.0f);
    topBorder2.backgroundColor = [UIColor marigoldBrown].CGColor;
    [holderView.layer addSublayer:topBorder2];
    [holderView2.layer addSublayer:topBorder2];
    
    NSString *fullName = [NSString combineNames:self.currentUser[@"firstName"] and:self.currentUser[@"lastName"]];
    self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(9, 160, 100, 100)];
    [self.profileImageView setImageWithString:fullName color:nil circular:YES];
    [self.view addSubview:self.profileImageView];
    self.profileImageView.layer.cornerRadius = 50;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor mainWhite].CGColor;
    
    [[UserController sharedInstance]retrieveProfileImageWithCallback:^(UIImage *profilePic) {
        if (profilePic) {
            self.profileImageView.image = profilePic;
            self.headerImageView.image = profilePic;
        }
    }];
    [[SingleGameController sharedInstance] updateGamesForUser:self.currentUser withBool:YES callback:^(NSArray * games) {
        self.singleGames = games;
        self.teamGames = [SingleGameController sharedInstance].teamGames;
        
        [[StatsController sharedInstance] retrieveOverallStatsForUser:self.currentUser andSingleGames:self.singleGames andTeamGames:self.teamGames callback:^(PersonalOverallStats *stats) {
            
            StatsViewController *svc = [StatsViewController new];
            self.navController = [[UINavigationController alloc]initWithRootViewController:svc];
            self.recordLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)stats.wins, (long)stats.loses];
            
            self.singleAmountLabel.text = [NSString stringWithFormat:@"%ld", stats.singleGamesPlayed];
            self.doubleAmountLabel.text = [NSString stringWithFormat:@"%ld", stats.teamGamesPlayed];
            
            self.navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            svc.overallStats = stats;
            svc.buttonSelected = 3;
            
        }];
    }];
    
    
    UITapGestureRecognizer *tapOnProfilePicture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profilePressed:)];
    tapOnProfilePicture.numberOfTapsRequired = 1;
    self.profileImageView.userInteractionEnabled = YES;
    [self.profileImageView addGestureRecognizer:tapOnProfilePicture];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:2];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 285, self.view.frame.size.width, 210) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    //[self.view addSubview:self.tableView];
    
    self.statsButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 51)];
    self.statsButton.backgroundColor = [UIColor darkColor];
    self.statsButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.statsButton setTitle:@"PERSONAL STATISTICS" forState:UIControlStateNormal];
    [self.statsButton setTitleColor:[UIColor mainWhite] forState:UIControlStateNormal];
    [self.statsButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.statsButton addTarget:self action:@selector(statsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.statsButton];
}

- (void)statsButtonPressed:(id)sender{
    
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"1V1 Statistics";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"2V2 Statistics";
    }else{
        cell.textLabel.text = @"Combined Stats";
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //cell.contentView.backgroundColor = [UIColor mainColorTransparent];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Personal Statistics";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    StatsViewController *svc = [StatsViewController new];
    UINavigationController *statsNavController = [[UINavigationController alloc]initWithRootViewController:svc];
    
    //statsNavController.transitioningDelegate = self;
    statsNavController.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [[SingleGameController sharedInstance] updateGamesForUser:self.currentUser withBool:YES callback:^(NSArray * games) {
        self.singleGames = games;
        self.teamGames = [SingleGameController sharedInstance].teamGames;
        if (indexPath.row == 0) {
            [[StatsController sharedInstance] retrieveSingleStatsForUser:self.currentUser andSingleGames:self.singleGames callback:^(PersonalSingleStats *stats) {
                svc.personalSingleStats = stats;
                svc.games = self.singleGames;
                svc.buttonSelected = 1;
                [self.navigationController presentViewController:statsNavController animated:YES completion:^{
                    
                }];
            }];
        }else if (indexPath.row == 1){
            [[StatsController sharedInstance] retrieveTeamStatsForUser:self.currentUser andTeamGames:self.teamGames callback:^(PersonalTeamStats *stats) {
                svc.personalTeamStats = stats;
                svc.buttonSelected = 2;
                svc.games = self.teamGames;
                [self.navigationController presentViewController:statsNavController animated:YES completion:^{
                    
                }];
            }];
        }else{
            [[StatsController sharedInstance] retrieveOverallStatsForUser:self.currentUser andSingleGames:self.singleGames andTeamGames:self.teamGames callback:^(PersonalOverallStats *stats) {
                svc.overallStats = stats;
                svc.buttonSelected = 3;
                
                [self.navigationController presentViewController:statsNavController animated:YES completion:^{
                    
                }];
            }];
        }

    }];

    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkGrayColor];
    header.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.contentView.backgroundColor = [UIColor transparentWhite];
}






#pragma mark - profile picture

- (void)profilePressed:(id)sender{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Profile Picture" message:@"Where do you want to get your image from?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera] == YES){
            
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            imagePicker.allowsEditing = YES;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Not Available on Device" message:@"This device does not have a camera option. Please choose Photo Library" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }

    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Take From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Set Avatar Image
    
    self.profileImageView.image = image;
    self.headerImageView.image = image;
    
    [[UserController sharedInstance]saveProfilePhoto:image];
    
    // Any other actions you want to take with the image would go here
    
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
