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
#import "TeamGameStats.h"
#import "NewGameCustomTableViewCell.h"
#import "StatsViewController.h"
#import "UserController.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate,  UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray *singleGames;
@property (nonatomic, strong) NSArray *teamGames;
@property (nonatomic, strong) PersonalSingleStats *persoanlStats;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *statsButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PFUser *currentUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];

    self.tabBarController.navigationItem.hidesBackButton = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.currentUser = [PFUser currentUser];
    
    NSString *fullName = [NSString combineNames:self.currentUser[@"firstName"] and:self.currentUser[@"lastName"]];
    self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 80, 100, 100)];
    [self.profileImageView setImageWithString:fullName color:nil circular:YES];
    [self.view addSubview:self.profileImageView];
    self.profileImageView.layer.cornerRadius = 50;
    self.profileImageView.clipsToBounds = YES;
    
    [[UserController sharedInstance]retrieveProfileImageWithCallback:^(UIImage *profilePic) {
        if (profilePic) {
            self.profileImageView.image = profilePic;
        }
    }];
    
    UITapGestureRecognizer *tapOnProfilePicture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profilePressed:)];
    tapOnProfilePicture.numberOfTapsRequired = 1;
    self.profileImageView.userInteractionEnabled = YES;
    [self.profileImageView addGestureRecognizer:tapOnProfilePicture];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:2];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 240, self.view.frame.size.width, 210) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.bounces = NO;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Single Game Stats";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"Team Game Stats";
    }else{
        cell.textLabel.text = @"Overall Stats";
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //cell.contentView.backgroundColor = [UIColor mainColorTransparent];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Stats";
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
