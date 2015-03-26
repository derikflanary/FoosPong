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
#import "EditGroupViewController.h"
#import "PlayerTableViewCell.h"
#import "GroupStatsViewController.h"

@interface CurrentGroupViewController () 
@property (nonatomic, strong) FoosButton *joinGroupButton;
@property (nonatomic, strong) FoosButton *createGroupButton;
@property (nonatomic, strong) AddGroupViewController *addGroupViewController;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) PFObject *currentGroup;
@property (nonatomic, strong) UIView *noGroupView;
@property (nonatomic, strong) FoosButton *addMembersButton;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PFUser *admin;
@property (nonatomic, strong) FoosButton *groupStatsButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;


@end

@implementation CurrentGroupViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = CGPointMake(160, 240);
    self.activityView.color = [UIColor darkColor];
    self.activityView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];

//    PFUser *currentUser = [PFUser currentUser];
//    if (!currentUser[@"currentGroup"]) {
//        [self noGroup];
//    }else{
//        
        [self checkForGroup];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIView *whiteWall = [[UIView alloc]initWithFrame:self.view.bounds];
    whiteWall.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:whiteWall];
    
//        UIBarButtonItem *addMemberButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMember:)];
//        self.tabBarController.navigationItem.rightBarButtonItem = addMemberButton;
    
    self.tabBarController.navigationItem.hidesBackButton = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 160, 320, 200) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = YES;
//    self.tableView.layer.cornerRadius = 10;
//    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    [self.tableView setEditing:NO];
    [self.view addSubview:self.tableView];
    
    self.addMembersButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 410, self.view.frame.size.width, 41)];
    self.addMembersButton.backgroundColor = [UIColor darkColor];
    self.addMembersButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.addMembersButton setTitle:@"EDIT TEAM" forState:UIControlStateNormal];
    [self.addMembersButton setTitleColor:[UIColor mainWhite] forState:UIControlStateNormal];
    [self.addMembersButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.addMembersButton addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
    [self.addMembersButton.layer setBorderColor:[[UIColor transparentCellWhite] CGColor]];
    
    
    self.groupStatsButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 360, self.view.frame.size.width, 41)];
    self.groupStatsButton.backgroundColor = [UIColor darkColor];
    self.groupStatsButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.groupStatsButton setTitle:@"GROUP STATISTICS" forState:UIControlStateNormal];
    [self.groupStatsButton setTitleColor:[UIColor mainWhite] forState:UIControlStateNormal];
    [self.groupStatsButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.groupStatsButton addTarget:self action:@selector(statsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.groupStatsButton.layer.shadowColor = [UIColor grayColor].CGColor;
    self.groupStatsButton.layer.shadowOffset = CGSizeMake(0, 1.0);
    self.groupStatsButton.layer.shadowOpacity = 1.0;
    self.groupStatsButton.layer.shadowRadius = 0.0;
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:3];
    
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.groupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerGameCell" ];
    if (!cell){
        cell = [PlayerTableViewCell new];
        
    }
    if (self.groupMembers.count > 0) {
        PFUser *user = [self.groupMembers objectAtIndex:indexPath.row];
        
        if (user == self.admin) {
            cell.textLabel.text = user.username;
            cell.detailTextLabel.text = @"Admin";
            //cell.detailTextLabel.text = [NSString combineNames:user[@"firstName"] and:user[@"lastName"]];
            //cell.adminLabel.text = @"Admin";
            
        }else{
        
            cell.textLabel.text = user.username;
            cell.detailTextLabel.text = [NSString combineNames:user[@"firstName"] and:user[@"lastName"]];
        }
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkGrayColor];
    header.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.contentView.backgroundColor = [UIColor transparentWhite];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                [self.view addSubview:self.groupStatsButton];
                
                [[GroupController sharedInstance]fetchMembersOfGroup:self.currentGroup Callback:^(NSArray *members) {
                    self.groupMembers = members.mutableCopy;
                    //NSUInteger theIndex = [self.groupMembers indexOfObject:self.admin];
                    
                    //id object = [self.groupMembers objectAtIndex:theIndex];
                    [self.groupMembers removeObject:self.admin];
                    [self.groupMembers insertObject:self.admin atIndex:0];
                    [self.activityView stopAnimating];
                    [self.tableView reloadData];
                    [[GroupController sharedInstance]saveGroupMembers:self.currentGroup andMembers:members];

                }];
                
                [[GroupController sharedInstance]fetchAdminForGroup:self.currentGroup callback:^(PFObject *admin) {
                    self.admin = admin;
                    if ([PFUser currentUser] == admin) {
                        [self.view addSubview:self.addMembersButton];
                    }
                }];
                if (self.noGroupView) {
                    [self.noGroupView removeFromSuperview];
                }
            }
        }
    }];
    
}

- (void)noGroup{
    
        [self.activityView stopAnimating];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [bluredEffectView setFrame:self.view.bounds];
        
        [self.view addSubview:bluredEffectView];
        
        self.noGroupView = [[UIView alloc]initWithFrame:CGRectMake(35, 80, 250, 250)];
        self.noGroupView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 60)];
        titleLabel.text = @"No Team Yet? Create or join a team today.";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        
        self.createGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 62)];
        self.createGroupButton.backgroundColor = [UIColor darkColor];
        self.createGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
        [self.createGroupButton setTitle:@"CREATE A TEAM" forState:UIControlStateNormal];
        [self.createGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
        [self.createGroupButton addTarget:self action:@selector(createPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        self.joinGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, 62)];
        self.joinGroupButton.backgroundColor = [UIColor darkColor];
        self.joinGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
        [self.joinGroupButton setTitle:@"JOIN AN EXISTING TEAM" forState:UIControlStateNormal];
        [self.joinGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.joinGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
        [self.joinGroupButton addTarget:self action:@selector(joinPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bluredEffectView];
//        [self.view addSubview:self.noGroupView];
        [self.view addSubview:titleLabel];
        [self.view addSubview:self.createGroupButton];
        [self.view addSubview:self.joinGroupButton];
//        [self.noGroupView addSubview:titleLabel];
//        [self.noGroupView addSubview:self.createGroupButton];
//        [self.noGroupView addSubview:self.joinGroupButton];
 
    
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
    EditGroupViewController *amvc = [EditGroupViewController new];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:amvc];
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

- (void)statsButtonPressed:(id)sender{
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:[GroupStatsViewController new]];
    
    navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:navController animated:YES completion:^{
        
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    

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
