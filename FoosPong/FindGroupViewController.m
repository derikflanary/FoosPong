//
//  FindGroupViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/25/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "FindGroupViewController.h"
#import "GroupTableViewCell.h"
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
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"Thonburi-Light" size:18],
      NSFontAttributeName, nil]];
    [self.navigationController.navigationBar setTintColor:[UIColor mainBlack]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor mainWhite]];

    self.view.backgroundColor = [UIColor mainWhite];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"60"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    
    [self.view addSubview:self.tableView];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search by Team Name or Organization";

    if ([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    

    //[self.tableView.superview addSubview:self.searchController.searchBar];


    //self.searchController.searchBar.prompt = @"Search by name or organization";

    // Do any additional setup after loading the view.
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

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.foundGroups count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [GroupTableViewCell new];
        
    }
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    PFObject *group = [self.foundGroups objectAtIndex:indexPath.row];
    if (!group) {
        cell.textLabel.text = @"";
    }else{
        NSArray *members = group[@"members"];
        if ([members containsObject:[PFUser currentUser]]) {
            //cell.textLabel.tintColor = [UIColor lightGrayColor];
            cell.backgroundColor = [UIColor colorWithWhite:.8 alpha:.2];
        }
        cell.textLabel.text = group[@"name"];
        cell.detailTextLabel.text = group[@"organization"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *selectedGroup = [self.foundGroups objectAtIndex:indexPath.row];
    
    UIAlertController *passwordAlert = [UIAlertController alertControllerWithTitle:@"Enter Team Password" message:@"Please enter the team's password to join" preferredStyle:UIAlertControllerStyleAlert];
    [passwordAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"password", @"password");
        
    }];
    [passwordAlert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *passwordTextfield = passwordAlert.textFields.firstObject;
        NSString *password = passwordTextfield.text;
        if ([password isEqualToString:selectedGroup[@"password"]]) {
            [[GroupController sharedInstance]addUser:[PFUser currentUser] toGroup:selectedGroup callback:^(BOOL *success) {
                
                [self.delegate groupSelected];
                
                UIAlertController *addedAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"You Were Added To %@", selectedGroup[@"name"]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [addedAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }]];
                [self presentViewController:addedAlert animated:YES completion:nil];
                
            }];
            
        }else{
            UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"Incorrect Password" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
            [failedAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //[self presentViewController:passwordAlert animated:YES completion:nil];
                return;
            }]];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            [self presentViewController:failedAlert animated:YES completion:nil];
        }
    }]];
    
    [passwordAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        return ;
    }]];
    [self presentViewController:passwordAlert animated:YES completion:nil];
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
