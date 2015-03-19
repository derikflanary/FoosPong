//
//  AddMembersViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "AddMembersViewController.h"
#import "UserController.h"
#import "NewGameCustomTableViewCell.h"
#import "GroupController.h"
#import "CreateMemberViewController.h"

@interface AddMembersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *nonMembers;
@property (nonatomic, strong) UIButton *addGuestMemberButton;
@property (nonatomic, strong) UITableView *contactsTableView;
@property (nonatomic, assign) BOOL searchUsers;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.addGuestMemberButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 410, 320, 41)];
    self.addGuestMemberButton.backgroundColor = [UIColor darkColor];
    self.addGuestMemberButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.addGuestMemberButton setTitle:@"Create Guest Member" forState:UIControlStateNormal];
    [self.addGuestMemberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addGuestMemberButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.addGuestMemberButton addTarget:self action:@selector(addGuestMemberPressed:) forControlEvents:UIControlEventTouchUpInside];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, 320, 250) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.placeholder = @"Search by name or organization";

    
    [self.view addSubview:self.tableView];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self findNonMembers];
}

- (void)findNonMembers{
    
    [[GroupController sharedInstance]notMembersOfCurrentGroupsearchString:self.searchController.searchBar.text callback:^(NSArray *nonMembers) {
         self.nonMembers = nonMembers.mutableCopy;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [self.nonMembers count];
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    
    if (!self.nonMembers) {
        return cell;
    }else{
    PFUser *user = [self.nonMembers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser *selectedUser = [self.nonMembers objectAtIndex:indexPath.row];
    
    UIAlertController *addPlayerAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Add %@ to your team?", selectedUser[@"username"]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [addPlayerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        PFUser *currentUser = [PFUser currentUser];
        [[GroupController sharedInstance]addUser:[self.nonMembers objectAtIndex:indexPath.row] toGroup:currentUser[@"currentGroup"]
         ];
        [self.nonMembers removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];

    }]];
    [addPlayerAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }]];
    [self presentViewController:addPlayerAlert animated:YES completion:nil];
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Add A User To Your Team";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addGuestMemberPressed:(id)sender{
    [self.navigationController pushViewController:[CreateMemberViewController new] animated:YES];
    
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
