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

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //NSString *name = [UserController sharedInstance].theCurrentUser.username;
    PFUser *currentUser = [PFUser currentUser];
    NSString *fullName =  [NSString new];
    [fullName combineNames:currentUser[@"firstName"] and:currentUser[@"lastName"]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [imageView setImageWithString:fullName];
    // Do any additional setup after loading the view.
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
