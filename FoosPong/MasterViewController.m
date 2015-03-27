//
//  MasterViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "MasterViewController.h"
#import "RNFrostedSidebar.h"
#import "InitialViewController.h"
#import "HomeViewController.h"
#import "GroupsViewController.h"
#import "ProfileViewController.h"
#import "HistoryViewController.h"
#import "CurrentGroupViewController.h"
#import "PersonalNotificationsViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "GroupHistoryViewController.h"

typedef NS_ENUM(NSInteger, SideBarSection) {
    SideBarSectionLogin,
    SideBarSectionMain,
    SideBarSectionPersonal,
    SideBarSectionGroups,
    SideBarSectionSettings,
};


@interface MasterViewController ()<RNFrostedSidebarDelegate>

@property (nonatomic, strong) RNFrostedSidebar *sideBar;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Thonburi-Light" size:18],
                                NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainBlack]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainWhite]];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(sideBarButtonPressed:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    self.navigationController.toolbarHidden = YES;
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    
    UIBarButtonItem * sideBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"17"] style:UIBarButtonItemStylePlain target:self action:@selector(sideBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = sideBarButton;

    self.tabBarController.navigationItem.rightBarButtonItem = sideBarButton;
     
    // Do any additional setup after loading the view.
}


- (void)sideBarButtonPressed:(id)sender{
    
   
    
    NSArray *barImages = @[ [UIImage imageNamed:@"Slice 2"],
                            [UIImage imageNamed:@"Artboard 1"],
                            [UIImage imageNamed:@"singleman"],
                            [UIImage imageNamed:@"team"],
                            [UIImage imageNamed:@"Slice 1"]];
    NSArray *colors = @[
                        [UIColor mainWhite],
                        [UIColor mainWhite],
                        [UIColor mainWhite],
                        [UIColor mainWhite],
                        [UIColor mainWhite]];
    
    
    
    self.sideBar = [[RNFrostedSidebar alloc] initWithImages:barImages selectedIndices:self.optionIndices borderColors:colors];
    self.sideBar.delegate = self;
    [self.sideBar showAnimated:YES];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index{
    
    if ([PFUser currentUser].username) {
        HomeViewController *hvc = [HomeViewController new];
        InitialViewController *ivc = [InitialViewController new];
        
        UITabBarController *profileTabBar = [UITabBarController new];
        HistoryViewController *historyVC = [HistoryViewController new];
        PersonalNotificationsViewController *pnvc = [PersonalNotificationsViewController new];
        ProfileViewController *pvc = [ProfileViewController new];
        pvc.tabBarItem.title = @"Profile";
        pvc.tabBarItem.image = [UIImage imageNamed:@"145"];
        
        historyVC.tabBarItem.title = @"History";
        historyVC.tabBarItem.image = [UIImage imageNamed:@"146"];
        pnvc.tabBarItem.title = @"Notifications";
        pnvc.tabBarItem.image = [UIImage imageNamed:@"167"];
        profileTabBar.viewControllers = @[pvc, historyVC, pnvc];
        
        
       
        
        UITabBarController *groupTabBar = [UITabBarController new];
        GroupsViewController *gvc = [GroupsViewController new];
        gvc.tabBarItem.title = @"Groups";
        gvc.tabBarItem.image = [UIImage imageNamed:@"70"];
        CurrentGroupViewController *cgvc = [CurrentGroupViewController new];
        cgvc.tabBarItem.title = @"Current Group";
        cgvc.tabBarItem.image = [UIImage imageNamed:@"85"];
        GroupHistoryViewController *ghvc = [GroupHistoryViewController new];
        ghvc.tabBarItem.title = @"Group Feed";
        ghvc.tabBarItem.image = [UIImage imageNamed:@"124"];
        groupTabBar.viewControllers = @[cgvc, gvc, ghvc];
        
        SettingViewController *svc = [SettingViewController new];
        
        
        SideBarSection section = index;
        
        switch (section) {
            case SideBarSectionLogin:{
                [PFUser logOut];
                [sidebar dismissAnimated:YES completion:^(BOOL finished) {
                    if (finished){
                    self.navigationController.viewControllers = @[ivc];
                    }
                }];
                break;
            }
            case SideBarSectionMain:{
                
                [sidebar dismissAnimated:YES completion:^(BOOL finished) {
                    if (finished) {
                        
                        self.navigationController.viewControllers = @[hvc];
                        
                    }
                }];
                break;
            }
            case SideBarSectionPersonal:{
                
                [sidebar dismissAnimated:YES completion:^(BOOL finished) {
                    if (finished) {
                        
                        self.navigationController.viewControllers = @[profileTabBar];
                        
                    }
                }];
                break;
            }
                
            case SideBarSectionGroups:{
                
                [sidebar dismissAnimated:YES completion:^(BOOL finished) {
                    if (finished) {
                        
                        self.navigationController.viewControllers = @[groupTabBar];
                        
                    }
                }];
                break;
            }
            case SideBarSectionSettings:{
                [sidebar dismissAnimated:YES completion:^(BOOL finished) {
                    if (finished) {
                        
                        self.navigationController.viewControllers = @[svc];
                        
                    }
                }];
                
                break;
            }
        }

    }else{
        UIAlertController *mustLoginAlert = [UIAlertController alertControllerWithTitle:@"Not Logged In" message:@"You must login before proceeding" preferredStyle:UIAlertControllerStyleAlert];
        [mustLoginAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [sidebar dismissAnimated:YES];
            return;
        }]];
        [self presentViewController:mustLoginAlert animated:YES completion:nil];
        
    }
    
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
