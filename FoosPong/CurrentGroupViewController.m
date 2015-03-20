//
//  CurrentGroupViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "CurrentGroupViewController.h"
#import "AddGroupViewController.h"
#import "FindGroupViewController.h"
#import "GroupController.h"
#import "AddMembersViewController.h"
#import "NewGameCustomTableViewCell.h"

@interface CurrentGroupViewController () 
@property (nonatomic, strong) UIButton *joinGroupButton;
@property (nonatomic, strong) UIButton *createGroupButton;
@property (nonatomic, strong) AddGroupViewController *addGroupViewController;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) PFObject *currentGroup;
@property (nonatomic, strong) UIView *noGroupView;
@property (nonatomic, strong) UIButton *addMembersButton;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation CurrentGroupViewController

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
//        UIBarButtonItem *addMemberButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMember:)];
//        self.tabBarController.navigationItem.rightBarButtonItem = addMemberButton;
    
    self.tabBarController.navigationItem.hidesBackButton = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, 320, 200) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    [self.tableView setEditing:NO];
    [self.view addSubview:self.tableView];
    
    self.addMembersButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 410, 320, 41)];
    self.addMembersButton.backgroundColor = [UIColor darkColor];
    self.addMembersButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.addMembersButton setTitle:@"Edit Team" forState:UIControlStateNormal];
    [self.addMembersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addMembersButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.addMembersButton addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser[@"currentGroup"]) {
        [self noGroup];
    }else{
    
    [self checkForGroup];
    }
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:3];
    
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.groupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
        
    }
    if (self.groupMembers.count > 0) {
        PFUser *user = [self.groupMembers objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
    }
   
    return cell;

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   return  @"Team Members";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - Group Checks

- (void)checkForGroup{
    
    [[GroupController sharedInstance]retrieveCurrentGroupWithCallback:^(PFObject *group, NSError *error) {
        
        if (!error) {
            if (!group) {
                [self noGroup];
            }else{
                self.currentGroup = group;
                self.tabBarController.title = group[@"name"];
                
                [[GroupController sharedInstance]fetchMembersOfGroup:self.currentGroup Callback:^(NSArray *members) {
                    self.groupMembers = members;
                    [self.tableView reloadData];

                }];
                
                self.isAdmin = [[GroupController sharedInstance]isUserAdmin];
                if (self.isAdmin) {
                    [self.view addSubview:self.addMembersButton];
                }
                if (self.noGroupView) {
                    [self.noGroupView removeFromSuperview];
                }
            }
        }
    }];
    
}

- (void)noGroup{
    
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [bluredEffectView setFrame:self.view.bounds];
        
        [self.view addSubview:bluredEffectView];
        
        self.noGroupView = [[UIView alloc]initWithFrame:CGRectMake(35, 80, 250, 250)];
        self.noGroupView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 250, 60)];
        titleLabel.text = @"No Group Yet? Create or join a group today.";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        
        self.createGroupButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 70, 250, 62)];
        self.createGroupButton.backgroundColor = [UIColor darkColor];
        self.createGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
        [self.createGroupButton setTitle:@"Create A Group" forState:UIControlStateNormal];
        [self.createGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
        [self.createGroupButton addTarget:self action:@selector(createPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.joinGroupButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 140, 250, 62)];
        self.joinGroupButton.backgroundColor = [UIColor darkColor];
        self.joinGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
        [self.joinGroupButton setTitle:@"Join An Existing Group" forState:UIControlStateNormal];
        [self.joinGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.joinGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
        [self.joinGroupButton addTarget:self action:@selector(joinPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bluredEffectView];
        [self.view addSubview:self.noGroupView];
        [self.noGroupView addSubview:titleLabel];
        [self.noGroupView addSubview:self.createGroupButton];
        [self.noGroupView addSubview:self.joinGroupButton];
 
    
}

#pragma mark - Buttons

- (void)createPressed:(id)sender{
    
    self.addGroupViewController = [AddGroupViewController new];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:self.addGroupViewController];
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

- (void)joinPressed:(id)sender{
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[FindGroupViewController new]];
    [self.view.window.rootViewController presentViewController:navController animated:YES completion:^{
        
    }];
}

- (void)addMember:(id)sender{
    AddMembersViewController *amvc = [AddMembersViewController new];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:amvc];
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser[@"currentGroup"]) {
        [self noGroup];
    }else{
        
        [self checkForGroup];
    }

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
