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


@interface ChoosePlayersViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong)PFUser *currentUser;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *availablePlayers;
@property (nonatomic, strong)NSMutableArray *currentPlayers;
@property (nonatomic, strong)UISearchController *searchController;
@property (nonatomic, strong)NSMutableArray *filteredPlayers;

@end

@implementation ChoosePlayersViewController



- (void)viewDidLoad {
        [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;
    
    self.currentUser = [UserController sharedInstance].theCurrentUser;
    
    self.currentPlayers = [NSMutableArray array];
    [self.currentPlayers insertObject:self.currentUser atIndex:0];
    
    
    UIBarButtonItem * startGameButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Game" style:UIBarButtonItemStylePlain target:self action:@selector(startGame:)];
    self.navigationItem.rightBarButtonItem = startGameButton;
    
    self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
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
    NSDictionary *playerOneDict = [self.currentPlayers objectAtIndex:0];
    NSDictionary *playerTwoDict = [self.currentPlayers objectAtIndex:1];
    gvc.playerOneName = [NSString stringWithFormat:@"%@", playerOneDict[@"username"]];
    gvc.playerTwoName = [NSString stringWithFormat:@"%@", playerTwoDict[@"username"]];
    gvc.playerOne = [self.currentPlayers objectAtIndex:0];
    gvc.playerTwo = [self.currentPlayers objectAtIndex:1];
    [self.navigationController pushViewController:gvc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Datasource

#define NUMBER_OF_STATIC_CELLS  2

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"Current Players";
    }else {
        return @"Available Players";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.currentPlayers count];
    }
    
        return [self.availablePlayers count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    if (indexPath.section == 0 && indexPath.row == 0){
        NSDictionary *playerDict = [self.currentPlayers objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", playerDict[@"username"]];
    }

    if (indexPath.section == 1) {
        NSDictionary *playerDict = [self.availablePlayers objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", playerDict[@"username"]];
    }
    
    return cell;
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
        [self.tableView reloadData];
        return;
    }else{
        
        
        self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
        //self.filteredPlayers = [NSMutableArray array];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.username CONTAINS[CD] %@", searchText];
        self.filteredPlayers = [self.availablePlayers filteredArrayUsingPredicate:pred].mutableCopy;
//        for (PFUser *user in self.availablePlayers) {
//            if ([user.username containsString:searchText]){
//                
//                [self.filteredPlayers addObject:user];
//            }
//        }
    }
    self.availablePlayers = self.filteredPlayers;
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
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
