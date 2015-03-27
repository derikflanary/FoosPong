//
//  AddGroupViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "AddGroupViewController.h"
#import "GroupController.h"
#import "Group.h"

@interface AddGroupViewController ()

@property (nonatomic, strong) UITextField *groupNameField;
@property (nonatomic, strong) UITextField *groupOrganiztionField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) FoosButton *addGroupButton;

@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainBlack]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainWhite]];

    self.view.backgroundColor = [UIColor mainWhite];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
//    UIColor* mainColor = [UIColor mainColor];
//    UIColor* darkColor = [UIColor darkColor];
    NSString* fontName = [NSString mainFont];
//    NSString* boldFontName = [NSString boldFont];
    
    self.groupNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 41)];
    self.groupNameField.backgroundColor = [UIColor whiteColor];
    self.groupNameField.placeholder = @"Team Name";
    self.groupNameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.groupNameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.groupNameField.layer.borderWidth = 1.0f;
    UIView* leftView2= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.groupNameField.leftViewMode = UITextFieldViewModeAlways;
    self.groupNameField.leftView = leftView2;
    self.groupNameField.autocorrectionType = UITextAutocorrectionTypeNo;


    self.groupOrganiztionField = [[UITextField alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 41)];
    self.groupOrganiztionField.backgroundColor = [UIColor whiteColor];
    self.groupOrganiztionField.placeholder = @"Organization Name";
    self.groupOrganiztionField.font = [UIFont fontWithName:fontName size:16.0f];
    self.groupOrganiztionField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.groupOrganiztionField.layer.borderWidth = 1.0f;
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.groupOrganiztionField.leftViewMode = UITextFieldViewModeAlways;
    self.groupOrganiztionField.leftView = leftView;
    self.groupNameField.autocorrectionType = UITextAutocorrectionTypeNo;

    
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 41)];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.placeholder = @"Team Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.passwordField.layer.borderWidth = 1.0f;
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView3;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;

    
    self.addGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 51)];
    self.addGroupButton.backgroundColor = [UIColor darkColor];
    self.addGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.addGroupButton setTitle:@"CREATE TEAM" forState:UIControlStateNormal];
    [self.addGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.addGroupButton addTarget:self action:@selector(createGroupPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.addGroupButton];
    [self.view addSubview:self.groupNameField];
    [self.view addSubview:self.groupOrganiztionField];
    [self.view addSubview:self.passwordField];
    // Do any additional setup after loading the view.
}

- (void)createGroupPressed:(id)sender{
    if (self.groupNameField.text && self.groupOrganiztionField.text) {
        Group *group = [Group new];
        group.name = self.groupNameField.text;
        group.organization = self.groupOrganiztionField.text;
        group.admin = [PFUser currentUser];
        group.password = self.passwordField.text;
        
        [[GroupController sharedInstance]addGroupforAdmin:group callback:^(BOOL *succeeded) {
            if (succeeded) {
                [[GroupController sharedInstance]findGroupsForUser:group.admin callback:^(NSArray *groups, NSError *error) {
                    [[GroupController sharedInstance]setCurrentGroup:[groups lastObject] callback:^(BOOL *success) {
                        [self dismissViewControllerAnimated:YES completion:^{
                        }];
                    }];
                }];
            }else{
                return;
            }
            
        }];
        
    }else{
        UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"Missing Data" message:@"Please give a team name and an organization" preferredStyle:UIAlertControllerStyleAlert];
        [failedAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            return;
        }]];
        [self presentViewController:failedAlert animated:YES completion:nil];

    }
    
}

- (void)cancelPressed:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard:(id)sender{
    
    [self.groupNameField resignFirstResponder];
    [self.groupNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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
