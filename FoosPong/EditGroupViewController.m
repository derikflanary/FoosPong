//
//  AddMembersViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/12/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "EditGroupViewController.h"
#import "UserController.h"
#import "NewGameCustomTableViewCell.h"
#import "GroupController.h"
#import "CreateMemberViewController.h"
#import "CurrentGroupViewController.h"
#import "MembersTableViewDataSource.h"

@interface EditGroupViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) NSMutableArray *nonMembers;
@property (nonatomic, strong) FoosButton *deleteGroupButton;
@property (nonatomic, strong) UITableView *contactsTableView;
@property (nonatomic, assign) BOOL searchUsers;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) MembersTableViewDataSource *membersDataSource;


@end

@implementation EditGroupViewController

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainBlack]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor transparentWhite]];

    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.deleteGroupButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 51)];
    self.deleteGroupButton.backgroundColor = [UIColor darkColor];
    self.deleteGroupButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.deleteGroupButton setTitle:@"DELETE TEAM" forState:UIControlStateNormal];
    [self.deleteGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteGroupButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.deleteGroupButton addTarget:self action:@selector(deleteGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.membersDataSource = [MembersTableViewDataSource new];
    self.membersDataSource.groupMembers = self.groupMembers;

    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self.membersDataSource;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.allowsSelection = NO;
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.placeholder = @"Search for user";
    self.searchController.searchBar.hidden = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Edit Team", @"Add Member"]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor mainBlack];
    self.segmentedControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont boldSystemFontOfSize:18];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
//   
//    UIBarButtonItem *seg = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [self setToolbarItems:@[spacer, seg, spacer]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.deleteGroupButton];


    //[self populateTableView];
}

#pragma mark - segmentedControl

- (void)segmentedControlChanged:(id)sender{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.tableView.dataSource = self.membersDataSource;
        self.searchController.searchBar.hidden = YES;
        self.tableView.allowsSelection = NO;
        [self.tableView reloadData];
        
        //[self populateTableView];
        
    }else{
        self.tableView.dataSource = self;
        self.searchController.searchBar.hidden = NO;
        self.tableView.allowsSelection = YES;
        [self.tableView reloadData];
    }
    
}

#pragma mark - searchBar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self findNonMembers];
    self.tableView.allowsSelection = NO;
}

- (void)findNonMembers{
    
    [[GroupController sharedInstance]notMembersOfCurrentGroupsearchString:self.searchController.searchBar.text callback:^(NSArray *nonMembers) {
         self.nonMembers = nonMembers.mutableCopy;
        [self.tableView reloadData];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.tableView.allowsSelection = YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.tableView.allowsSelection = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.tableView.allowsSelection = YES;
}


- (void)populateTableView{
    PFUser *currentUser = [PFUser currentUser];
    
    [[GroupController sharedInstance]fetchMembersOfGroup:currentUser[@"currentGroup"] Callback:^(NSArray *members) {
        self.membersDataSource.groupMembers = members.mutableCopy;
//        [self.membersDataSource.groupMembers removeObject:currentUser];
        [self.tableView reloadData];
        
    }];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [self.nonMembers count];
    
}


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
    
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        PFUser *selectedUser = [self.nonMembers objectAtIndex:indexPath.row];
        
        UIAlertController *addPlayerAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Add %@ to your team?", selectedUser[@"username"]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [addPlayerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
            PFUser *currentUser = [PFUser currentUser];
            [[GroupController sharedInstance]addUser:[self.nonMembers objectAtIndex:indexPath.row] toGroup:currentUser[@"currentGroup"] callback:^(BOOL *success) {
                [self.nonMembers removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }];
        }]];
        
        [addPlayerAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:addPlayerAlert animated:YES completion:nil];
        });
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Add A User To Your Team";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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


#pragma mark - Other Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelPressed:(id)sender{
    [self.tableView setEditing:NO animated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addGuestMemberPressed:(id)sender{
    [self.navigationController pushViewController:[CreateMemberViewController new] animated:YES];
    
}

- (void)deleteGroupButtonPressed:(id)sender{
    UIAlertController *deleteGroupAlert = [UIAlertController alertControllerWithTitle:@"Delete Your Team?" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    
    [deleteGroupAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [[GroupController sharedInstance]deleteGroupCallback:^(BOOL *succeeded) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.tableView setEditing:NO animated:YES];
            }];
        }];
        
    }]];
    
    [deleteGroupAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        return;
    }]];
    [self presentViewController:deleteGroupAlert animated:YES completion:nil];
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
