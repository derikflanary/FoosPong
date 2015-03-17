//
//  FindGroupViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "FindGroupViewController.h"
#import "NewGameCustomTableViewCell.h"
#import "GroupController.h"

@interface FindGroupViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic, strong) UITextField *groupNameField;
@property (nonatomic, strong) UITextField *groupOrganizationField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *foundGroups;

@end

@implementation FindGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.groupNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 80, 320, 41)];
    self.groupNameField.backgroundColor = [UIColor mainColor];
    self.groupNameField.placeholder = @"Group Name";
    self.groupNameField.font = [UIFont fontWithName:[NSString boldFont] size:16.0f];
    self.groupNameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.groupNameField.layer.borderWidth = 1.0f;
    
    self.groupOrganizationField = [[UITextField alloc]initWithFrame:CGRectMake(0, 120, 320, 41)];
    self.groupOrganizationField.backgroundColor = [UIColor whiteColor];
    self.groupOrganizationField.placeholder = @"Organization Name";
    self.groupOrganizationField.font = [UIFont fontWithName:[NSString boldFont] size:16.0f];
    self.groupOrganizationField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.groupOrganizationField.layer.borderWidth = 1.0f;
    
    [self.view addSubview:self.groupNameField];
    [self.view addSubview:self.groupOrganizationField];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 280, 320, 250) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.clipsToBounds = YES;
    
    [self.view addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //self.searchController.searchBar.prompt = @"Search by name or organization";
    
    
    
    


    // Do any additional setup after loading the view.
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.searchController.searchBar.prompt = @"Search by name or by organizations";
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [[GroupController sharedInstance]findGroupsByName:self.searchController.searchBar.text withCallback:^(NSArray *foundGroups) {
                self.foundGroups = foundGroups.mutableCopy;
                [self.tableView reloadData];
            }];
}

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    [[GroupController sharedInstance]findGroupsByName:self.searchController.searchBar.text withCallback:^(NSArray *foundGroups) {
//        self.foundGroups = foundGroups.mutableCopy;
//        [self.tableView reloadData];
//    }];
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)cancelPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.foundGroups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
        
    }
    PFObject *group = [self.foundGroups objectAtIndex:indexPath.row];
    if (!group) {
        cell.textLabel.text = @"";
    }else{
        cell.textLabel.text = group[@"name"];
    }
    return cell;
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
