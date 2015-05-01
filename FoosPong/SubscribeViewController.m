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
#import "SubscriptionTableViewCell.h"

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
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    [self.view addSubview:self.tableView];
    NSString *buttonTitle = @"Subscribe Now";
    
    self.perMonthButton = [[BrownButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 51)];
    self.perMonthButton.backgroundColor = [UIColor marigoldBrown];
    self.perMonthButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.perMonthButton setTitle:[buttonTitle uppercaseString] forState:UIControlStateNormal];
    [self.perMonthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.perMonthButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.perMonthButton addTarget:self action:@selector(perMonthButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.perMonthButton];

    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.perMonthButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_perMonthButton, _tableView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_tableView(>=100)]-(==0)-[_perMonthButton(==52)]-(==0)-|" options:0 metrics:nil views:viewsDictionary]];
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=200)-[_yearButton(==52)]-(==0)-|" options:0 metrics:nil views:viewsDictionary]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_perMonthButton]-(==0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_tableView]-(==0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDictionary]];
    

    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 4){
        return 80;
    }
    return 120;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    }else if (section == 1){
        return @"Individual Statistics";
    }else if (section == 2){
        return @"Ranking System";
    }else if (section == 3){
        return @"Team Feed";
    }else{
        return @"";
    }

}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SubscriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    if (!cell){
        cell = [SubscriptionTableViewCell new];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:20];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    if (indexPath.section == 0) {
        NSString *string = @"Subscribe to gain access to the best features of Foos";
        cell.label.text = [string uppercaseString];
        
    }else if (indexPath.section == 1){
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"stats"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = imageView;
        
    }else if (indexPath.section == 2){
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ranking"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = imageView;
    }else if (indexPath.section == 3){
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feed"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = imageView;
    }else{
        NSString *string = @"And More!";
        cell.label.text = [string uppercaseString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor vanilla];
    header.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
//    header.contentView.backgroundColor = [UIColor transparentWhite];
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
