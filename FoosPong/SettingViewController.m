//
//  SettingViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/26/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SettingViewController.h"
#import "RulesViewController.h"

@interface SettingViewController ()

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rulesButton = [[UIBarButtonItem alloc] initWithTitle:@"Rules" style:UIBarButtonItemStylePlain target:self action:@selector(rulesPressed:)];
    self.navigationItem.rightBarButtonItem = rulesButton;
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:4];
    // Do any additional setup after loading the view.
}

-(void)rulesPressed:(id)sender{
    [self.navigationController pushViewController:[RulesViewController new] animated:YES];
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
