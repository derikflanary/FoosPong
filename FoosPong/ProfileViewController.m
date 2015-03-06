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
#import "UIColor+ExtraColorTools.h"
#import "HMSegmentedControl.h"
#import "SingleGameController.h"
#import "TeamGameController.h"
#import "StatsController.h"
#import "PersonalStats.h"
#import "PulldownMenu.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PulldownMenuDelegate, UIScrollViewDelegate> {
    PulldownMenu *pulldownMenu;
}

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) NSArray *singleGames;
@property (nonatomic, strong) NSArray *teamGames;
@property (nonatomic, strong) PersonalStats *stats;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.navigationItem.hidesBackButton = YES;
    NSArray *images = @[[UIImage imageNamed:@"74"],
                        [UIImage imageNamed:@"17"],
                        [UIImage imageNamed:@"167"]];
//    NSArray *titles = @[@"Profile", @"History", @"Messages"];

    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc]initWithSectionImages:images sectionSelectedImages:images];
    segmentedControl.frame = CGRectMake(10, 60, 300, 60);
    segmentedControl.selectionIndicatorColor = [UIColor mainColor];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = [UIColor darkColor];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:segmentedControl];
    
    
    
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@", currentUser[@"firstName"]);
    
    NSString *fullName = [NSString combineNames:currentUser[@"firstName"] and:currentUser[@"lastName"]];
    self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 120, 100, 100)];
    [self.profileImageView setImageWithString:fullName color:nil circular:YES];
    self.profileImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.profileImageView];
    
    UITapGestureRecognizer *tapOnProfilePicture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profilePressed:)];
    tapOnProfilePicture.numberOfTapsRequired = 1;
    self.profileImageView.userInteractionEnabled = YES;
    [self.profileImageView addGestureRecognizer:tapOnProfilePicture];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:2];
    
    [[SingleGameController sharedInstance] updateGamesForUser:currentUser withBool:YES callback:^(NSArray * games) {
        self.singleGames = games;
        self.teamGames = [SingleGameController sharedInstance].teamGames;
        self.stats = [[StatsController sharedInstance] getStatsForUser:currentUser andSingleGames:self.singleGames andTeamGames:self.teamGames];
    }];
    
    UIButton *statsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 230, 320, 50)];
    [statsButton addTarget:self action:@selector(menuTap:) forControlEvents:UIControlEventTouchUpInside];
    statsButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [statsButton setTitle:@"Stats" forState:UIControlStateNormal];
    [statsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [statsButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    statsButton.backgroundColor = [UIColor mainColor];
    [self.view addSubview:statsButton];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(8, 280, 302, 250) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    layout.itemSize = CGSizeMake(200, 250);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    pulldownMenu = [[PulldownMenu alloc] initWithView:self.view];
    pulldownMenu.topMarginPortrait = 280;
    [self.view addSubview:pulldownMenu];
    
    [pulldownMenu insertButton:@"Wins"];
    [pulldownMenu insertButton:@"Loses"];
    [pulldownMenu insertButton:@"Other"];
    
    pulldownMenu.delegate = self;
    
    [pulldownMenu loadMenu];
}

- (void)menuTap:(id)sender {
    [pulldownMenu animateDropDown];
}

- (void)menuItemSelected:(NSIndexPath *)indexPath{
    
}

-(void)pullDownAnimated:(BOOL)open{
    
}


#pragma mark - collectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [UICollectionViewCell new];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 50, 0, 0);
}

#pragma mark - segmented control

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

#pragma mark - profile picture

- (void)profilePressed:(id)sender{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Profile Picture" message:@"Where do you want to get your image from" preferredStyle:UIAlertControllerStyleActionSheet];
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
