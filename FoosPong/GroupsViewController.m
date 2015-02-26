//
//  GroupsViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GroupsViewController.h"
#import "AddGroupViewController.h"

@interface GroupsViewController ()

@property (nonatomic, strong) UIButton *joinGroupButton;
@property (nonatomic, strong) UIButton *createGroupButton;
@property (nonatomic, strong) AddGroupViewController *addGroupViewController;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.

    
    
    UIColor* mainColor = [UIColor colorWithRed:189.0/255 green:242.0/255 blue:139.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:255/255 green:101/255 blue:57/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";

    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 300, 100)];
    titleLabel.text = @"No Group Yet? Create or join a group today.";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    
    self.createGroupButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 160, 320, 62)];
    self.createGroupButton.backgroundColor = darkColor;
    self.createGroupButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.createGroupButton setTitle:@"Create A Group" forState:UIControlStateNormal];
    [self.createGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.createGroupButton addTarget:self action:@selector(createPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.joinGroupButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 230, 320, 62)];
    self.joinGroupButton.backgroundColor = darkColor;
    self.joinGroupButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.joinGroupButton setTitle:@"SIGN UP HERE" forState:UIControlStateNormal];
    [self.joinGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.joinGroupButton addTarget:self action:@selector(joinPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.createGroupButton];
    [self.view addSubview:self.joinGroupButton];
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:3];
    
}

- (void)createPressed:(id)sender{
    
    self.addGroupViewController = [AddGroupViewController new];
    [self presentViewController:self.addGroupViewController animated:YES completion:^{
        
    }];
    
}



- (void)joinPressed:(id)sender{
    
    

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
