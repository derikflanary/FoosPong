//
//  PersonalNotificationsViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "PersonalNotificationsViewController.h"

@interface PersonalNotificationsViewController ()

@end

@implementation PersonalNotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];

    UILabel *comingSoonlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 200, 100)];
    comingSoonlabel.text = @"Feature Coming Soon";
    comingSoonlabel.numberOfLines = 0;
    comingSoonlabel.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:comingSoonlabel];
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
