//
//  FindGroupViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "FindGroupViewController.h"

@interface FindGroupViewController ()

@end

@implementation FindGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UILabel *comingSoonlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 200, 100)];
    comingSoonlabel.text = @"Feature Coming Soon";
    comingSoonlabel.numberOfLines = 0;
    [self.view addSubview:comingSoonlabel];

    // Do any additional setup after loading the view.
}

- (void)cancelPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
