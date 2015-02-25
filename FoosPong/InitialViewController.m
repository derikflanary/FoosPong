//
//  MainViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "InitialViewController.h"
#import "HomeViewController.h"
#import "GroupsViewController.h"
#import "ProfileViewController.h"
#import "UserController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "SignUpViewController.h"
#import "LogViewController.h"
#import "RNFrostedSidebar.h"

@interface InitialViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, RNFrostedSidebarDelegate>

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *guestButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HomeViewController *hvc;
@property (nonatomic, strong) ProfileViewController *pvc;
@property (nonatomic, strong) GroupsViewController *gvc;
@property (nonatomic, strong) RNFrostedSidebar *sideBar;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation InitialViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * sideBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"17"] style:UIBarButtonItemStylePlain target:self action:@selector(sideBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = sideBarButton;
    self.navigationItem.hidesBackButton = YES;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedLeft:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    
    UIColor* mainColor = [UIColor colorWithRed:189.0/255 green:242.0/255 blue:139.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:1.0f];
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FoosBallButton"]];
    self.imageView.frame = self.view.frame;
    [self.view addSubview:self.imageView];

    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 383, 320, 62)];
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.guestButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 320, 62)];
    self.guestButton.backgroundColor = mainColor;
    self.guestButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.guestButton setTitle:@"Play As Guest" forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.guestButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.guestButton addTarget:self action:@selector(guestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.guestButton];
    
//    //self.tabBarController = [UITabBarController new];
//    self.hvc = [HomeViewController new];
//    //self.hvc.tabBarItem.title = @"Main";
//    self.gvc = [GroupsViewController new];
//    //gvc.tabBarItem.title = @"Group";
//    self.pvc = [ProfileViewController new];
//    //self.pvc.tabBarItem.title = @"Profile";
//    //self.tabBarController.viewControllers = @[self.hvc, gvc, self.pvc];
    
    
    
}

#pragma mark - SideBar

- (void)sideBarButtonPressed:(id)sender{
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
    
    NSArray *barImages = @[ [UIImage imageNamed:@"68"],
                            [UIImage imageNamed:@"85"],
                            [UIImage imageNamed:@"74"],
                            [UIImage imageNamed:@"70"],
                            [UIImage imageNamed:@"101"]];
    NSArray *colors = @[
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f]];

    self.hvc = [HomeViewController new];
    self.gvc = [GroupsViewController new];
    self.pvc = [ProfileViewController new];
    
    self.sideBar = [[RNFrostedSidebar alloc] initWithImages:barImages selectedIndices:self.optionIndices borderColors:colors];
     self.sideBar.delegate = self;
    [self.sideBar showAnimated:YES];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index{
   
    if (index == 1) {
        [sidebar dismissAnimated:YES];
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                [self.navigationController pushViewController:self.hvc animated:YES];
            }
        }];
    }
    
    if (index == 2) {
        [sidebar dismissAnimated:YES];
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                [self.navigationController pushViewController:self.pvc animated:YES];
            }
        }];
    }
    if (index == 3) {
        [sidebar dismissAnimated:YES];
        [sidebar dismissAnimated:YES completion:^(BOOL finished) {
            if (finished) {
                [self.navigationController pushViewController:self.gvc animated:YES];
            }
        }];
    }
}

- (void)swipedLeft:(id)sender{
    NSArray *barImages = @[ [UIImage imageNamed:@"68"],
                            [UIImage imageNamed:@"85"],
                            [UIImage imageNamed:@"74"],
                            [UIImage imageNamed:@"70"],
                            [UIImage imageNamed:@"101"]];
    NSArray *colors = @[
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f],
                        [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:.5f]];
    
    self.hvc = [HomeViewController new];
    self.gvc = [GroupsViewController new];
    self.pvc = [ProfileViewController new];
    
    self.sideBar = [[RNFrostedSidebar alloc] initWithImages:barImages selectedIndices:self.optionIndices borderColors:colors];
    self.sideBar.delegate = self;
    [self.sideBar showAnimated:YES];
    [self.sideBar showAnimated:YES];
}


#pragma mark - Login Buttons

-(void)loginPressed:(id)selector{
    
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    [self presentViewController:logInController animated:YES completion:nil];
    
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [logInController dismissViewControllerAnimated:YES completion:^{
        [[UserController sharedInstance] findCurrentUser];
        [[UserController sharedInstance] updateUsers];

    }];
    //[self.navigationController showViewController:self.tabBarController sender:self];
}

-(void)guestPressed:(id)sender{
    [[UserController sharedInstance] addGuestUser];

    self.hvc.isGuest = YES;
    [self.navigationController pushViewController:self.hvc animated:YES];
    
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
