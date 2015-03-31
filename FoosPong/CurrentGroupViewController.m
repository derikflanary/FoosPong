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
#import "TeamMemberStatsViewController.h"
#import "RankingController.h"
#import "TeamMemberCustomTableViewCell.h"
#import "GameDetailViewController.h"

@interface CurrentGroupViewController () <FindGroupViewControllerDelegate>
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
@property (nonatomic, strong) UIVisualEffectView *bluredEffectView;
@property (nonatomic, strong) NSMutableArray *memberRankings;
@property (nonatomic, strong) UILabel *messageLabel;

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
    background.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:background];
    
    UIView *whiteWall = [[UIView alloc]initWithFrame:self.view.bounds];
    whiteWall.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:whiteWall];
    
//        UIBarButtonItem *addMemberButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMember:)];
//        self.tabBarController.navigationItem.rightBarButtonItem = addMemberButton;
    
    self.tabBarController.navigationItem.hidesBackButton = YES;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setEditing:NO];
    [self.view addSubview:self.tableView];
    
    
    self.addMembersButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 51)];
    self.addMembersButton.backgroundColor = [UIColor darkColor];
    self.addMembersButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.addMembersButton setTitle:@"EDIT TEAM" forState:UIControlStateNormal];
    [self.addMembersButton setTitleColor:[UIColor mainWhite] forState:UIControlStateNormal];
    [self.addMembersButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.addMembersButton addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
    [self.addMembersButton.layer setBorderColor:[[UIColor transparentCellWhite] CGColor]];
    
    
    self.groupStatsButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 51)];
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
    
    if ([self.groupMembers count] < 1) {
//        
//        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        self.messageLabel.text = @"Not apart of any teams? Join or create a team below.";
//        self.messageLabel.textColor = [UIColor darkColor];
//        self.messageLabel.numberOfLines = 0;
//        self.messageLabel.textAlignment = NSTextAlignmentCenter;
//        self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [self.messageLabel sizeToFit];
//        
//        self.tableView.backgroundView = self.messageLabel;
        
        return 0;
    }else{
        self.messageLabel.text = @"";
        return [self.groupMembers count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TeamMemberCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamMemberCell" ];
    if (!cell){
        cell = [TeamMemberCustomTableViewCell new];
        
    }
    if (self.groupMembers.count > 0) {
        
        PFUser *user = [self.groupMembers objectAtIndex:indexPath.row];
        PFUser *admin = self.currentGroup[@"admin"];
        
        if ([user.objectId isEqualToString: admin.objectId]) {
            
            if ([self.memberRankings count] > 0) {
                
                PFObject *rankingObject = [self.memberRankings objectAtIndex:indexPath.row];
                NSNumber *ranking = rankingObject[@"rank"];
                cell.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", ranking];
                
                
            }
            
            cell.adminLabel.text = @"Admin";
            //cell.detailTextLabel.text = [NSString combineNames:user[@"firstName"] and:user[@"lastName"]];
            //cell.adminLabel.text = @"Admin";
            
        }else{
            
            if ([self.memberRankings count] > 0) {
                PFObject *rankingObject = [self.memberRankings objectAtIndex:indexPath.row];
                NSNumber *ranking = rankingObject[@"rank"];
                cell.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", ranking];
            
            }
        }
        
        cell.nameLabel.text = [user.username uppercaseString];
        cell.fullNameLabel.text = [NSString combineNames:user[@"firstName"] and:user[@"lastName"]];
        cell.profileImageView.backgroundColor = [UIColor darkColor];
        [cell.profileImageView setImage:[UIImage imageNamed:@"74"]];

    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
    if ([self.groupMembers count] < 1) {
       return @"";
   }else{
    return  @"Team Members";
   }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkColor];
    header.textLabel.font = [UIFont fontWithName:[NSString mainFont] size:18];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.contentView.backgroundColor = [UIColor transparentCellWhite];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TeamMemberStatsViewController *gsvc = [TeamMemberStatsViewController new];
    gsvc.ranking = [self.memberRankings objectAtIndex:indexPath.row];
    gsvc.user = [self.groupMembers objectAtIndex:indexPath.row];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gsvc];
    
//    navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:navController animated:YES completion:^{
        
    }];

    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Group Checks

- (void)checkForGroup{
    self.memberRankings = [NSMutableArray array];
    
    if (![PFUser currentUser][@"currentGroup"]) {
        [self noGroup];
        [self.activityView stopAnimating];
    }else{
        
        //self.currentGroup = [PFUser currentUser][@"currentGroup"];
        
        [[GroupController sharedInstance]retrieveCurrentGroupWithCallback:^(PFObject *group, NSError *error) {
        
        if (!error) {
            if (!group) {
                [self noGroup];
            }else{
                self.currentGroup = group;
                
                
                [[GroupController sharedInstance]fetchMembersOfGroup:self.currentGroup Callback:^(NSArray *members) {
                    [self.activityView stopAnimating];
                    PFUser *currentUser = [PFUser currentUser];
                    BOOL isInGroup = false;
                    for (PFUser *member in members) {
                        if ([member.objectId isEqualToString:currentUser.objectId]) {
                            isInGroup = YES;
                            break;
                        }
                    }
                    
                    if (isInGroup) {
                        
                        self.groupMembers = members.mutableCopy;
                        self.tabBarController.title = [group[@"name"] uppercaseString];
                        [self.view addSubview:self.groupStatsButton];
                        
                        [[RankingController sharedInstance]retrieveRankingsForGroup:group forUsers:self.groupMembers withCallBack:^(NSArray *rankings) {
                            for (PFUser *user in self.groupMembers) {
                                
                                for (PFObject *ranking in rankings) {
                                    PFUser *userForRanking = ranking[@"user"];
                                    if ([userForRanking.objectId isEqualToString:user.objectId]) {
                                        [self.memberRankings addObject:ranking];
                                    }
                                }
                            }
                            [self.tableView reloadData];
                            [[GroupController sharedInstance]fetchAdminForGroup:self.currentGroup callback:^(PFObject *admin) {
                                self.admin = admin;
                                if ([[PFUser currentUser].objectId isEqualToString:admin.objectId]) {
                                    [self.view addSubview:self.addMembersButton];
                                    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 350);
                                    
                                }
                            }];
                            
                            if (self.noGroupView) {
                                [self.noGroupView removeFromSuperview];
                            }

                            self.messageLabel.text = @"";
                            [self.tableView reloadData];
                        }];

                    }else{
                        //need to remove current group
                        [self noGroup];
                        [[RankingController sharedInstance]removeRankingForGroup:self.currentGroup];
                        [[GroupController sharedInstance]setCurrentGroup:nil callback:^(BOOL *success) {
                            NSLog(@"current Group removed");
                        }];
                        
                        
                    }
                    
                }];
            }
        }
        }];
    }
}

- (void)noGroup{

    [self.activityView stopAnimating];

    self.noGroupView = [[UIView alloc]initWithFrame:self.view.frame];
    self.noGroupView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 60)];
    titleLabel.text = @"No Team Yet? Create or join a team today.";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    self.createGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, 62)];
    self.createGroupButton.backgroundColor = [UIColor darkColor];
    self.createGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.createGroupButton setTitle:@"CREATE A TEAM" forState:UIControlStateNormal];
    [self.createGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.createGroupButton addTarget:self action:@selector(createPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.joinGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 62)];
    self.joinGroupButton.backgroundColor = [UIColor darkColor];
    self.joinGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.joinGroupButton setTitle:@"JOIN AN EXISTING TEAM" forState:UIControlStateNormal];
    [self.joinGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.joinGroupButton addTarget:self action:@selector(joinPressed:) forControlEvents:UIControlEventTouchUpInside];

    //[self.noGroupView addSubview:titleLabel];
    [self.noGroupView addSubview:self.createGroupButton];
    [self.noGroupView addSubview:self.joinGroupButton];
    [self.view addSubview:self.noGroupView];

    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    self.messageLabel.text = @"Not apart of any teams? Join or create a team below.";
    self.messageLabel.textColor = [UIColor darkColor];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [self.messageLabel sizeToFit];
    
    self.tableView.backgroundView = self.messageLabel;

 
    
}

#pragma mark - Buttons

- (void)createPressed:(id)sender{
    
    self.addGroupViewController = [AddGroupViewController new];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:self.addGroupViewController];
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

- (void)joinPressed:(id)sender{
    
    FindGroupViewController *fgvc = [FindGroupViewController new];
    fgvc.delegate = self;

    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:fgvc];
    [self.view.window.rootViewController presentViewController:navController animated:YES completion:^{
        
    }];
}

- (void)addMember:(id)sender{
    EditGroupViewController *egvc = [EditGroupViewController new];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:egvc];
    egvc.groupMembers = self.groupMembers;
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

- (void)statsButtonPressed:(id)sender{
    
    GameDetailViewController *gameDetailViewController = [GameDetailViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:gameDetailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self.navigationController presentViewController:navController animated:YES completion:^{
        
    }];

    
}

-(void)viewDidAppear:(BOOL)animated{
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)groupSelected{
    [self checkForGroup];
    [self.noGroupView removeFromSuperview];
    [self.bluredEffectView removeFromSuperview];
    
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
