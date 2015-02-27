//
//  AddGroupViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "AddGroupViewController.h"

@interface AddGroupViewController ()

@property (nonatomic, strong) UITextField *groupNameField;

@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor* mainColor = [UIColor mainColor];
    UIColor* darkColor = [UIColor darkColor];
    NSString* fontName = [NSString mainFont];
    NSString* boldFontName = [NSString boldFont];
    
    self.groupNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 320, 41)];
    self.groupNameField.backgroundColor = [UIColor whiteColor];
    self.groupNameField.placeholder = @"Group Name";
    self.groupNameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.groupNameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.groupNameField.layer.borderWidth = 1.0f;
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