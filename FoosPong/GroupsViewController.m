//
//  GroupsViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/24/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupTableViewCell.h"
#import "GroupController.h"
#import "AddGroupViewController.h"
#import "FindGroupViewController.h"


@interface GroupsViewController ()<UITableViewDataSource, UITableViewDelegate, FindGroupViewControllerDelegate>



@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) FoosButton *joinGroupButton;
@property (nonatomic, strong) FoosButton *createGroupButton;
@property (nonatomic, strong) UIViewController *addGroupViewController;
@property (nonatomic, strong) PFObject *currentGroup;
@property (nonatomic, strong) UIBarButtonItem *findGroupButton;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation GroupsViewController

-(void)viewWillAppear:(BOOL)animated{
    //self.tabBarController.navigationItem.leftBarButtonItem = self.findGroupButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = CGPointMake(160, 240);
    self.activityView.color = [UIColor darkColor];
    self.activityView.hidesWhenStopped = YES;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];


    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];

    
//    self.findGroupButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(joinGroupButtonPressed:)];
//    self.navigationController.toolbarHidden = NO;
//    [self setToolbarItems:@[self.findGroupButton]];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.dataSource = self;
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:self.tableView];
    
    self.joinGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 51)];
    self.joinGroupButton.backgroundColor = [UIColor darkColor];
    self.joinGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.joinGroupButton setTitle:@"JOIN AN EXISTING TEAM" forState:UIControlStateNormal];
    [self.joinGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.joinGroupButton addTarget:self action:@selector(joinPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.joinGroupButton];
    
    self.createGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, 51)];
    self.createGroupButton.backgroundColor = [UIColor darkColor];
    self.createGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.createGroupButton setTitle:@"CREATE A TEAM" forState:UIControlStateNormal];
    [self.createGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.createGroupButton addTarget:self action:@selector(createPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createGroupButton];
    
    [self checkForGroups];
    
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:3];
    
}

- (void)joinGroupButtonPressed:(id)sender{
    
    FindGroupViewController *fgvc = [FindGroupViewController new];
    fgvc.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:fgvc];
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

-(void)checkForGroups{
    
    [[GroupController sharedInstance]findGroupsForUser:[PFUser currentUser] callback:^(NSArray * groups, NSError *error) {
            if (!error) {
                if(!groups){
                    [self noCurrentGroup];
                }else{
                    self.groups = groups;
                    [[GroupController sharedInstance]retrieveCurrentGroupWithCallback:^(PFObject *group, NSError *error) {
                        if (!error) {
                            self.currentGroup = group;
                        }else{
                            NSLog(@"%@", error);
                        }
                        [self.activityView stopAnimating];
                        [self.tableView reloadData];

                    }];
                    //                    self.currentGroup = [PFUser currentUser][@"currentGroup"];
//                    self.title = self.currentGroup[@"name"];
                }
                
            }else{
                NSLog(@"%@", error);
            }
            
        }];
}

- (void)noCurrentGroup{
    
    if (!self.currentGroup) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [bluredEffectView setFrame:self.view.bounds];
        
        [self.view addSubview:bluredEffectView];
        
        UIView *noGroupView = [[UIView alloc]initWithFrame:CGRectMake(35, 80, self.view.frame.size.width, 250)];
        noGroupView.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 60)];
        titleLabel.text = @"No Team Yet? Create or join a team today.";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        
        self.createGroupButton.frame = CGRectMake(0, 70, self.view.frame.size.width, 62);
        
        self.joinGroupButton.frame = CGRectMake(0, 140, self.view.frame.size.width, 62);
        
        [self.view addSubview:bluredEffectView];
        [self.view addSubview:titleLabel];
        [self.view addSubview:self.createGroupButton];
        [self.view addSubview:self.joinGroupButton];
    }

    
    
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.groups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" ];
    if (!cell){
        cell = [GroupTableViewCell new];
    }
    
    PFObject *group = self.groups[indexPath.row];
    
    if ([group.objectId isEqualToString: self.currentGroup.objectId]) {
        cell.backgroundColor = [UIColor darkColorTransparent];
        cell.textLabel.textColor = [UIColor mainWhite];
        cell.textLabel.text = [NSString stringWithFormat:@"%@: (Current Group)", group[@"name"]];
    }else{
        cell.textLabel.text = group[@"name"];
        cell.backgroundColor = [UIColor transparentCellWhite];
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    
    cell.detailTextLabel.text = group[@"organization"];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *group = self.groups[indexPath.row];
    PFObject *currentGroup = [PFUser currentUser][@"currentGroup"];
    if (group.objectId == currentGroup.objectId) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }else{
        [[GroupController sharedInstance]setCurrentGroup:group callback:^(BOOL *success) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            self.title = group[@"name"];
            self.currentGroup = [PFUser currentUser][@"currentGroup"];
            [tableView reloadData];

        }];
    }
}

-(void)groupSelected{
    [self checkForGroups];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
