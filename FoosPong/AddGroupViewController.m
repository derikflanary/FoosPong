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

@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *createGroupButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createGroupPressed:)];
    self.navigationItem.rightBarButtonItem = createGroupButton;

    
//    UIColor* mainColor = [UIColor mainColor];
//    UIColor* darkColor = [UIColor darkColor];
    NSString* fontName = [NSString mainFont];
//    NSString* boldFontName = [NSString boldFont];
    
    self.groupNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 100, 320, 41)];
    self.groupNameField.backgroundColor = [UIColor whiteColor];
    self.groupNameField.placeholder = @"Group Name";
    self.groupNameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.groupNameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.groupNameField.layer.borderWidth = 1.0f;
    
    self.groupOrganiztionField = [[UITextField alloc]initWithFrame:CGRectMake(0, 150, 320, 41)];
    self.groupOrganiztionField.backgroundColor = [UIColor whiteColor];
    self.groupOrganiztionField.placeholder = @"Organization Name";
    self.groupOrganiztionField.font = [UIFont fontWithName:fontName size:16.0f];
    self.groupOrganiztionField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.groupOrganiztionField.layer.borderWidth = 1.0f;

    [self.view addSubview:self.groupNameField];
    [self.view addSubview:self.groupOrganiztionField];
    // Do any additional setup after loading the view.
}

- (void)createGroupPressed:(id)sender{
    if (self.groupNameField.text && self.groupOrganiztionField.text) {
        Group *group = [Group new];
        group.name = self.groupNameField.text;
        group.organization = self.groupOrganiztionField.text;
        group.admin = [PFUser currentUser];
        
        [[GroupController sharedInstance]addGroupforAdmin:group callback:^(BOOL *succeeded) {
            if (succeeded) {
                [[GroupController sharedInstance]findGroupsForUser:group.admin callback:^(NSArray *groups, NSError *error) {
                    [[GroupController sharedInstance]setCurrentGroup:[groups lastObject]];
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                }];
            }else{
                return;
            }
            
        }];
        
    }else{
        UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"Missing Data" message:@"Please give a group name and an organization" preferredStyle:UIAlertControllerStyleAlert];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
