//
//  SubscribeViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 4/6/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubscriptionController.h"
#import "BrownButton.h"
#import "AddGroupViewController.h"

@interface SubscribeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BrownButton *perMonthButton;
@property (nonatomic, strong) BrownButton *yearButton;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainWhite]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor darkColor]];
    
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor darkColor];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.perMonthButton = [[BrownButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 51)];
    self.perMonthButton.backgroundColor = [UIColor marigoldBrown];
    self.perMonthButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.perMonthButton setTitle:@"Subscribe Now" forState:UIControlStateNormal];
    [self.perMonthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.perMonthButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.perMonthButton addTarget:self action:@selector(perMonthButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.perMonthButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:self.view.frame];
    self.detailLabel.textColor = [UIColor mainWhite];
    self.detailLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    self.detailLabel.text = @"Subscribe to gain access to the Team feature of Foos. Creating a team includes the following features:";
    self.detailLabel.numberOfLines = 0;
//    [self.view addSubview:self.detailLabel];
//    self.yearButton = [[BrownButton alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 51)];
//    self.yearButton.backgroundColor = [UIColor marigoldBrown];
//    self.yearButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
//    [self.yearButton setTitle:@"$50 For 12 Months" forState:UIControlStateNormal];
//    [self.yearButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
//    [self.yearButton addTarget:self action:@selector(yearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.yearButton];

    
    
    self.perMonthButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.yearButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_perMonthButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=200)-[_perMonthButton(==52)]-(==0)-|" options:0 metrics:nil views:viewsDictionary]];
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=200)-[_yearButton(==52)]-(==0)-|" options:0 metrics:nil views:viewsDictionary]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_perMonthButton]-(==0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    

    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (!cell){
        cell = [UITableViewCell new];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = @"Subscribe to gain access to the Team feature of Foos. Creating a team includes the following features: Detailed Statistics, Ranking System, team feed.";
    return cell;
}


- (void)perMonthButtonPressed:(id)sender{
    [[SubscriptionController sharedInstance]requestPurchaseCallback:^(BOOL *success, NSError *error) {
        if (!error) {
            NSLog(@"Purchased");
            
            UIAlertController *subscribedAlert = [UIAlertController alertControllerWithTitle:@"You Have Successfully Subscribed!" message:@"You can now create a team." preferredStyle:UIAlertControllerStyleAlert];
            [subscribedAlert addAction:[UIAlertAction actionWithTitle:@"Let's Go!" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[AddGroupViewController new]];
                [self presentViewController:navController animated:YES completion:^{
                    
                }];
            }]];
        }
    }];
    
}

- (void)yearButtonPressed:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
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
