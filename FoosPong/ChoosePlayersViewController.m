//
//  NewGameViewController.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//


#import "ChoosePlayersViewController.h"
#import "NewGameCustomTableViewCell.h"
#import "GameViewController.h"
#import "UserController.h"
#import "HMSegmentedControl.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionCurrent,
    TableViewSectionAvailable,
    TableViewSectionTeamTwo
};


@interface ChoosePlayersViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong)PFUser *currentUser;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *availablePlayers;
@property (nonatomic, strong)NSMutableArray *currentPlayers;
@property (nonatomic, strong)UISearchController *searchController;
@property (nonatomic, strong)NSMutableArray *filteredPlayers;
@property (nonatomic, strong)HMSegmentedControl *segmentedControl;

@end

@implementation ChoosePlayersViewController



- (void)viewDidLoad {
        [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.toolbarHidden = NO;
//    UIBarButtonItem *addGuestButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Player" style:UIBarButtonItemStylePlain target:self action:@selector(addGuestPressed:)];
//    
    UIBarButtonItem * startGameButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Game" style:UIBarButtonItemStylePlain target:self action:@selector(startGame:)];
    
//    self.navigationItem.rightBarButtonItems= @[startGameButton, addGuestButton];

    
    self.segmentedControl = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"1v1", @"2v2"]];

    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentedControl.frame = CGRectMake(160, 0, 100, 44);
    self.segmentedControl.selectionIndicatorColor = [UIColor darkColor];
    self.segmentedControl.verticalDividerEnabled = YES;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl sizeToFit];
    
    UIBarButtonItem *seg = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
    [self setToolbarItems:@[startGameButton, seg]];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;
    
    self.currentUser = [UserController sharedInstance].theCurrentUser;
    
    self.currentPlayers = [NSMutableArray array];
    [self.currentPlayers insertObject:self.currentUser atIndex:0];
    
    
    self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
- (void)segmentedControlChangedValue:(id)sender{
    [self.tableView reloadData];
}

-(void)startGame:(id)sender{
    
    if ([self.currentPlayers count] == 1) {
        UIAlertController *notEnoughPlayersAlert = [UIAlertController alertControllerWithTitle:@"Only One Player" message:@"You must have two players to play." preferredStyle:UIAlertControllerStyleAlert];
        [notEnoughPlayersAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            return;
        }]];
        [self presentViewController:notEnoughPlayersAlert animated:YES completion:nil];
    }else{
    
    GameViewController *gvc = [GameViewController new];
    gvc.playerOne = [self.currentPlayers objectAtIndex:0];
    gvc.playerTwo = [self.currentPlayers objectAtIndex:1];
    [self.navigationController pushViewController:gvc animated:YES];
    }
}

-(void)addGuestPressed:(id)sender{
    
    UIAlertController *addGuestAlert = [UIAlertController alertControllerWithTitle:@"Add A Guest Player" message:@"Please give the guest player a name" preferredStyle:UIAlertControllerStyleAlert];
    [addGuestAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Guest's Name", @"Guest");
        
    }];
    [addGuestAlert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *theguestName = addGuestAlert.textFields.firstObject;
        NSString *guestName = [NSString string];
        guestName = theguestName.text;
        if ([guestName isEqualToString:@""]) {
            [guestName isEqualToString:@"Guest"];
        }
        if ([self.currentPlayers count] < 2) {
            PFUser *guest = [PFUser new];
            guest.username = guestName;
            [self.currentPlayers addObject:guest];
            [self.tableView reloadData];
        }else if ([self.currentPlayers count] == 2){
            PFUser *guest = [PFUser new];
            guest.username = guestName;
            [self.availablePlayers insertObject:guest atIndex:0];
            [self.tableView reloadData];
        }

    }]];
    
    [addGuestAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        return ;
    }]];
    [self presentViewController:addGuestAlert animated:YES completion:nil];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Datasource

#define NUMBER_OF_STATIC_CELLS  2

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.segmentedControl.selectedSegmentIndex == 1) {
        return TableViewSectionTeamTwo + 1;
    }else{
    
    return TableViewSectionAvailable + 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    TableViewSection tableViewSection = section;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        switch (tableViewSection) {
            case TableViewSectionCurrent:{
                return @"Team One Players";
                break;
            }
            case TableViewSectionAvailable:{
                return @"Available Players";
                break;
            }
            case TableViewSectionTeamTwo:{
                return @"Team Two Players";
                break;
            }

    }

    }return @"Section";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TableViewSection tableViewSection = section;
    switch (tableViewSection) {
        case TableViewSectionCurrent:{
            return [self.currentPlayers count];
            break;
        }
        case TableViewSectionAvailable:{
           return [self.availablePlayers count];
        }
        case TableViewSectionTeamTwo:{
            return [self.currentPlayers count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    TableViewSection tableViewSection = indexPath.section;
    switch (tableViewSection) {
        case TableViewSectionCurrent:{
            NSDictionary *playerDict = [self.currentPlayers objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", playerDict[@"username"]];
            return cell;
            break;
        }
        case TableViewSectionAvailable:{
            NSDictionary *playerDict = [self.availablePlayers objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", playerDict[@"username"]];
            return cell;
        }
        case TableViewSectionTeamTwo:{
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    
    if (proposedDestinationIndexPath.section == 0 && self.currentPlayers.count == 2) {
        return sourceIndexPath;
    }else{
    
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (sourceIndexPath.section == 1 && destinationIndexPath.section == 0) {
        PFUser *user = [self.availablePlayers objectAtIndex:sourceIndexPath.row];
        [self.availablePlayers removeObjectAtIndex:sourceIndexPath.row];
        [self.currentPlayers insertObject:user atIndex:destinationIndexPath.row];
    }
    if (sourceIndexPath.section == 1 && destinationIndexPath.section == 1) {
        PFUser *user = [self.availablePlayers objectAtIndex:sourceIndexPath.row];
        [self.availablePlayers removeObjectAtIndex:sourceIndexPath.row];
        [self.availablePlayers insertObject:user atIndex:destinationIndexPath.row];
    }
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
        PFUser *user = [self.currentPlayers objectAtIndex:sourceIndexPath.row];
        [self.currentPlayers removeObjectAtIndex:sourceIndexPath.row];
        [self.currentPlayers insertObject:user atIndex:destinationIndexPath.row];
    }
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 1) {
        PFUser *user = [self.currentPlayers objectAtIndex:sourceIndexPath.row];
        [self.currentPlayers removeObjectAtIndex:sourceIndexPath.row];
        [self.availablePlayers insertObject:user atIndex:destinationIndexPath.row];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
    
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - SearchController

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    if ([searchText isEqualToString:@""]) {
        
        self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
        for (PFUser *user in self.currentPlayers) {
            if ([self.availablePlayers containsObject:user]) {
                [self.availablePlayers removeObject:user];
            }
        }
        [self.tableView reloadData];
        return;
    }else{
        //self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
        //self.filteredPlayers = [NSMutableArray array];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.username CONTAINS[CD] %@", searchText];
        self.filteredPlayers = [self.availablePlayers filteredArrayUsingPredicate:pred].mutableCopy;
    }
    self.availablePlayers = self.filteredPlayers;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
    for (PFUser *user in self.currentPlayers) {
        if ([self.availablePlayers containsObject:user]) {
            [self.availablePlayers removeObject:user];
        }
    }
    [self.tableView reloadData];
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
