//
//  NewGameViewController.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//


#import "ChoosePlayersViewController.h"
#import "NewGameCustomTableViewCell.h"
#import "SingleGameViewController.h"
#import "UserController.h"
#import "HMSegmentedControl.h"
#import "TeamGameViewController.h"
#import "GroupController.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionCurrent,
    TableViewSectionAvailable,
};

typedef NS_ENUM(NSInteger, TableView2TeamSection) {
    TableView2TeamSectionTeam1,
    TableView2TeamSectionTeam2,
    TableView2TeamSectionAvailable
};


@interface ChoosePlayersViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *availablePlayers;
@property (nonatomic, strong) NSMutableArray *currentPlayers;
@property (nonatomic, strong) NSMutableArray *teamTwoPlayers;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *filteredPlayers;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) BOOL isTwoPlayer;
@property (nonatomic, assign) BOOL cellSelected;
@property (nonatomic, strong) NSIndexPath *selectedPath;
@property (nonatomic, assign) NSInteger userIndex;
@property (nonatomic, strong) FoosButton *startButton;
@property (nonatomic, strong) NSArray *searchAvailablePlayers;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UILabel *messageLabel;


@end

@implementation ChoosePlayersViewController


-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = NO;
}


- (void)viewDidLoad {
        [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = CGPointMake(160, 240);
    self.activityView.color = [UIColor darkColor];
    self.activityView.hidesWhenStopped = YES;
    
    [self.activityView startAnimating];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //self.navigationController.toolbarHidden = NO;
//    UIBarButtonItem *addGuestButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Player" style:UIBarButtonItemStylePlain target:self action:@selector(addGuestPressed:)];
//
//    UIBarButtonItem * startGameButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Game" style:UIBarButtonItemStylePlain target:self action:@selector(startGame:)];
    
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage mainBackgroundImage]];
    background.frame = self.view.frame;
    [self.view addSubview:background];
    
    self.startButton = [[FoosButton alloc]initWithFrame:CGRectMake(0, 410, self.view.frame.size.width, 51)];
    self.startButton.backgroundColor = [UIColor darkColor];
    self.startButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.startButton setTitle:@"START GAME" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.startButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];

    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"1 V 1", @"2 V 2"]];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.tintColor = [UIColor darkColor];
    self.segmentedControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
   [self.segmentedControl sizeToFit];
    
    UIBarButtonItem *seg = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:@[spacer,seg, spacer]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 410) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = NO;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.activityView];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
        self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    
    
    //self.availablePlayers = [UserController sharedInstance].usersWithoutCurrentUser.mutableCopy;
    [[GroupController sharedInstance]retrieveCurrentGroupWithCallback:^(PFObject *group, NSError *error) {
        self.tableView.tableHeaderView = self.searchController.searchBar;

        [[GroupController sharedInstance]fetchMembersOfGroup:group Callback:^(NSArray *members) {
            self.availablePlayers = members.mutableCopy;
            self.currentUser = [PFUser currentUser];
            for (PFUser *user in self.availablePlayers) {
                if ([user.objectId isEqualToString:self.currentUser.objectId]) {
                    self.currentUser = user;
                    
                }
            }
            [self.availablePlayers removeObject:self.currentUser];
            
            self.currentPlayers = [NSMutableArray array];
            [self.currentPlayers insertObject:self.currentUser atIndex:0];
            
            if ([self.currentPlayers count] <2) {
                [self.currentPlayers addObject:[PFUser new]];
            }
            
            self.title = group[@"name"];
            self.searchAvailablePlayers = members;
            [self.activityView stopAnimating];
            [self.tableView reloadData];
        }];
        
    }];
   
    self.teamTwoPlayers = [NSMutableArray array];
    [self.teamTwoPlayers addObject:[PFUser new]];
    [self.teamTwoPlayers addObject:[PFUser new]];

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.isTwoPlayer = NO;
    }else{
        self.isTwoPlayer = YES;
    }
    
    self.cellSelected = NO;
    
    
    
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - segmentedControl

- (void)segmentedControlChangedValue:(id)sender{
    if (self.teamTwoPlayers.count > 0) {
        for (PFUser *user in self.teamTwoPlayers) {
            if (user.username) {
                [self.availablePlayers addObject:user];
            }
        }
        [self.teamTwoPlayers removeAllObjects];
        [self.teamTwoPlayers addObject:[PFUser new]];
        [self.teamTwoPlayers addObject:[PFUser new]];
    }
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.isTwoPlayer = NO;
    }else{
        self.isTwoPlayer = YES;
    }
    [self.tableView reloadData];
}

-(void)startGame:(id)sender{
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        if ([self.currentPlayers count] == 2 ) {
            
            PFUser *player1 = [self.currentPlayers objectAtIndex:0];
            PFUser *player2 = [self.currentPlayers objectAtIndex:1];
            
            if (player1.username && player2.username) {
                
                SingleGameViewController *gvc = [SingleGameViewController new];
                UINavigationController *singleGameNavController = [[UINavigationController alloc]initWithRootViewController:gvc];
                gvc.playerOne = [self.currentPlayers objectAtIndex:0];
                gvc.playerTwo = [self.currentPlayers objectAtIndex:1];
                
                [self.navigationController presentViewController:singleGameNavController animated:YES completion:^{
                    
                }];
                
            }else{
                UIAlertController *notEnoughPlayersAlert = [UIAlertController alertControllerWithTitle:@"Only One Player" message:@"You must have two players to play." preferredStyle:UIAlertControllerStyleAlert];
                [notEnoughPlayersAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    return;
                }]];
                [self presentViewController:notEnoughPlayersAlert animated:YES completion:nil];
            }
        }else{
            
            UIAlertController *notEnoughPlayersAlert = [UIAlertController alertControllerWithTitle:@"Only One Player" message:@"You must have two players to play." preferredStyle:UIAlertControllerStyleAlert];
            [notEnoughPlayersAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            return;
            }]];
            [self presentViewController:notEnoughPlayersAlert animated:YES completion:nil];
            
        }

    }else if(self.segmentedControl.selectedSegmentIndex == 1){
        if ([self.currentPlayers count] == 2 && [self.teamTwoPlayers count] == 2) {
            PFUser *p1 = [self.currentPlayers objectAtIndex:0];
            PFUser *p2 = [self.currentPlayers objectAtIndex:1];
            PFUser *p3 = [self.teamTwoPlayers objectAtIndex:0];
            PFUser *p4 = [self.teamTwoPlayers objectAtIndex:1];
            if (p1.username && p2.username && p3.username && p4.username) {
                TeamGameViewController *tgvc = [TeamGameViewController new];
                UINavigationController *teamGameNavController = [[UINavigationController alloc]initWithRootViewController:tgvc];
                
                tgvc.teamOne = [NSArray arrayWithArray:self.currentPlayers];
                tgvc.teamTwo = [NSArray arrayWithArray:self.teamTwoPlayers];
                
                [self.navigationController presentViewController:teamGameNavController animated:YES completion:^{
                    
                }];

            }else{
                UIAlertController *notEnoughPlayersAlert = [UIAlertController alertControllerWithTitle:@"Not Enough Players" message:@"You must have two players on each team to play." preferredStyle:UIAlertControllerStyleAlert];
                [notEnoughPlayersAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    return;
                }]];
                [self presentViewController:notEnoughPlayersAlert animated:YES completion:nil];

            }
        }else{
            UIAlertController *notEnoughPlayersAlert = [UIAlertController alertControllerWithTitle:@"Not Enough Players" message:@"You must have two players on each team to play." preferredStyle:UIAlertControllerStyleAlert];
            [notEnoughPlayersAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                return;
            }]];
            [self presentViewController:notEnoughPlayersAlert animated:YES completion:nil];
        }

    }
}



#pragma mark - TableView Datasource

#define NUMBER_OF_STATIC_CELLS  2

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.currentUser[@"currentGroup"]) {
        
        [self.activityView stopAnimating];
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        self.messageLabel.text = @"No current players to play with. Please join a team to play.";
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [self.messageLabel sizeToFit];
        
        self.tableView.backgroundView = self.messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
   
    }else{
        self.messageLabel.text = @"";
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            return TableViewSectionAvailable + 1;
        }else{
        
        return TableView2TeamSectionAvailable + 1;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        TableViewSection tableViewSection = section;
        switch (tableViewSection) {
            case TableViewSectionCurrent:{
                return @"Current Players";
                break;
            }
            case TableViewSectionAvailable:{
                return @"Available Players";
            }
        }

    }else{
        TableView2TeamSection tableView2TeamSection = section;
        switch (tableView2TeamSection) {
            case TableView2TeamSectionTeam1:{
                return @"Team One";
                break;
            }
            case TableView2TeamSectionTeam2:{
                return @"Team Two";
                break;
            }
            case TableView2TeamSectionAvailable:{
                return @"Available Players";
                break;
            }
                
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
    TableViewSection tableViewSection = section;
        switch (tableViewSection) {
            case TableViewSectionCurrent:{
                return [self.currentPlayers count];
                break;
            }
            case TableViewSectionAvailable:{
                return [self.availablePlayers count];
            }
        }
    }else{
        TableView2TeamSection tableView2TeamSection = section;
        switch (tableView2TeamSection) {
            case TableView2TeamSectionTeam1:{
                return [self.currentPlayers count];
                break;
            }
            case TableView2TeamSectionTeam2:{
                return [self.teamTwoPlayers count];
                break;
            }
            case TableView2TeamSectionAvailable:{
                return [self.availablePlayers count];
                break;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
      
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        TableViewSection tableViewSection = indexPath.section;
        switch (tableViewSection) {
            case TableViewSectionCurrent:{
                
                PFUser *theUser = [self.currentPlayers objectAtIndex:indexPath.row];
                if (!theUser.username) {
                    cell.textLabel.text = @"Add Player";
                    cell.textLabel.textColor = [UIColor colorWithWhite:.5 alpha:.7];
                }else{
                    cell.textLabel.text = theUser.username;
                }
                cell.detailTextLabel.text = @"";
                return cell;
                break;
            }
            case TableViewSectionAvailable:{
                PFUser *theUser = [self.availablePlayers objectAtIndex:indexPath.row];
                cell.textLabel.text = theUser.username;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.detailTextLabel.text = @"";
                return cell;
            }
        }
    }else{
        TableView2TeamSection tableView2TeamSection = indexPath.section;
        switch (tableView2TeamSection) {
            case TableView2TeamSectionTeam1:{
                PFUser *theUser = [self.currentPlayers objectAtIndex:indexPath.row];
                if (!theUser.username) {
                    cell.textLabel.text = @"Add Player";
                    cell.textLabel.textColor = [UIColor colorWithWhite:.5 alpha:.7];

                }else{
                    cell.textLabel.text = theUser.username;
                }
                if (indexPath.row == 0) {
                    cell.detailTextLabel.text = @"Attacker";
                }else{
                    cell.detailTextLabel.text = @"Defender";
                }
                return cell;
                break;

            }
            case TableView2TeamSectionTeam2:{
                PFUser *theUser = [self.teamTwoPlayers objectAtIndex:indexPath.row];
                
                if (!theUser.username) {
                    cell.textLabel.text = @"Add Player";
                    cell.textLabel.textColor = [UIColor colorWithWhite:.5 alpha:.7];

                }else{
                    cell.textLabel.text = theUser.username;
                }
                
                if (indexPath.row == 0) {
                    cell.detailTextLabel.text = @"Attacker";
                    
                }else{
                    cell.detailTextLabel.text = @"Defender";
                }
                return cell;
                break;

            }
            case TableView2TeamSectionAvailable:{
                PFUser *theUser = [self.availablePlayers objectAtIndex:indexPath.row];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.text = theUser.username;
                cell.detailTextLabel.text = @"";
                return cell;

            }
        }
    }
}

#pragma mark - tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellSelected == NO) {
        self.cellSelected = YES;
        self.selectedPath = indexPath;
        
    }else{
        
        [tableView beginUpdates];
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
        [tableView cellForRowAtIndexPath:self.selectedPath].selected = NO;
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            if (self.selectedPath.section == 1 && indexPath.section == 0) {
                PFUser *fromUser = [self.availablePlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.currentPlayers objectAtIndex:indexPath.row];
                if (!toUser.username){
                    [self.currentPlayers replaceObjectAtIndex:indexPath.row withObject:[self.availablePlayers objectAtIndex:self.selectedPath.row]];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.availablePlayers removeObjectAtIndex:self.selectedPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{
                [self.currentPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.availablePlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
                }
            }
            if (self.selectedPath.section == 1 && indexPath.section == 1) {
                PFUser *fromUser = [self.availablePlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.availablePlayers objectAtIndex:indexPath.row];
                [self.availablePlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.availablePlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
            }
            if (self.selectedPath.section == 0 && indexPath.section == 0) {
                PFUser *fromUser = [self.currentPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.currentPlayers objectAtIndex:indexPath.row];
                [self.currentPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.currentPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
            }
            if (self.selectedPath.section == 0 && indexPath.section == 1) {
                PFUser *fromUser = [self.currentPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.availablePlayers objectAtIndex:indexPath.row];
                if (!fromUser.username){
                    [self.currentPlayers replaceObjectAtIndex:self.selectedPath.row withObject:[self.availablePlayers objectAtIndex:indexPath.row]];
                    [tableView reloadRowsAtIndexPaths:@[self.selectedPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.availablePlayers removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{

                    [self.availablePlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                    [self.currentPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                    [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                    [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
                }
            }
        }else{
            
            if (self.selectedPath.section == 1 && indexPath.section == 0) {
                PFUser *fromUser = [self.teamTwoPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.currentPlayers objectAtIndex:indexPath.row];
                [self.currentPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.teamTwoPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
            }
            if (self.selectedPath.section == 0 && indexPath.section == 1) {
                PFUser *fromUser = [self.currentPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.teamTwoPlayers objectAtIndex:indexPath.row];
                [self.teamTwoPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.currentPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];

            }
            if (self.selectedPath.section == 2 && indexPath.section == 0) {
                PFUser *fromUser = [self.availablePlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.currentPlayers objectAtIndex:indexPath.row];
                if (!toUser.username){
                    [self.currentPlayers replaceObjectAtIndex:indexPath.row withObject:[self.availablePlayers objectAtIndex:self.selectedPath.row]];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.availablePlayers removeObjectAtIndex:self.selectedPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{
                    [self.currentPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                    [self.availablePlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                    [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                    [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
                }
            }
            if (self.selectedPath.section == 0 && indexPath.section == 2) {
                PFUser *fromUser = [self.currentPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.availablePlayers objectAtIndex:indexPath.row];
                
                if (!fromUser.username){
                    [self.currentPlayers replaceObjectAtIndex:self.selectedPath.row withObject:[self.availablePlayers objectAtIndex:indexPath.row]];
                    [tableView reloadRowsAtIndexPaths:@[self.selectedPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.availablePlayers removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{
                    [self.availablePlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                    [self.currentPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                    [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                    [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];

                }
            }
            if (self.selectedPath.section == 2 && indexPath.section == 1) {
                PFUser *fromUser = [self.availablePlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.teamTwoPlayers objectAtIndex:indexPath.row];
                if (!toUser.username){
                    [self.teamTwoPlayers replaceObjectAtIndex:indexPath.row withObject:[self.availablePlayers objectAtIndex:self.selectedPath.row]];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.availablePlayers removeObjectAtIndex:self.selectedPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.selectedPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{

                    [self.teamTwoPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                    [self.availablePlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                    [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                    [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
                }
            }
            if (self.selectedPath.section == 1 && indexPath.section == 2) {
                PFUser *fromUser = [self.teamTwoPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.availablePlayers objectAtIndex:indexPath.row];
                if (!fromUser.username){
                    [self.teamTwoPlayers replaceObjectAtIndex:self.selectedPath.row withObject:[self.availablePlayers objectAtIndex:indexPath.row]];
                    [tableView reloadRowsAtIndexPaths:@[self.selectedPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.availablePlayers removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{

                    [self.availablePlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                    [self.teamTwoPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                    [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                    [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
                }
            }
            if (self.selectedPath.section == 1 && indexPath.section == 1) {
                PFUser *fromUser = [self.teamTwoPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.teamTwoPlayers objectAtIndex:indexPath.row];
                [self.teamTwoPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.teamTwoPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
            }
            if (self.selectedPath.section == 0 && indexPath.section == 0) {
                PFUser *fromUser = [self.currentPlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.currentPlayers objectAtIndex:indexPath.row];
                [self.currentPlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.currentPlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
            }
            if (self.selectedPath.section == 2 && indexPath.section == 2) {
                PFUser *fromUser = [self.availablePlayers objectAtIndex:self.selectedPath.row];
                PFUser *toUser = [self.availablePlayers objectAtIndex:indexPath.row];
                [self.availablePlayers replaceObjectAtIndex:indexPath.row withObject:fromUser];
                [self.availablePlayers replaceObjectAtIndex:self.selectedPath.row withObject:toUser];
                [tableView moveRowAtIndexPath:self.selectedPath toIndexPath: indexPath];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:self.selectedPath];
            }
        }
        //self.searchAvailablePlayers = self.availablePlayers;
        self.cellSelected = NO;
        [tableView endUpdates];
        [tableView reloadData];
    }
}



//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return YES;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
//    
//    if (self.segmentedControl.selectedSegmentIndex == 0) {
//        if (proposedDestinationIndexPath.section == 0 && self.currentPlayers.count == 2) {
//            return sourceIndexPath;
//        }else{
//    
//            return proposedDestinationIndexPath;
//        }
//    }else{
//        if (proposedDestinationIndexPath.section == 0 && self.currentPlayers.count == 2) {
//            return sourceIndexPath;
//        }else if(proposedDestinationIndexPath.section == 1 && self.teamTwoPlayers.count ==2){
//            return sourceIndexPath;
//        }else{
//            return proposedDestinationIndexPath;
//        }
//    }
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    
//    if (self.segmentedControl.selectedSegmentIndex == 0){
//        if (sourceIndexPath.section == 1 && destinationIndexPath.section == 0) {
//            PFUser *user = [self.availablePlayers objectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 1 && destinationIndexPath.section == 1) {
//            PFUser *user = [self.availablePlayers objectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
//            PFUser *user = [self.currentPlayers objectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 0 && destinationIndexPath.section == 1) {
//            PFUser *user = [self.currentPlayers objectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//    }else{
//        if (sourceIndexPath.section == 1 && destinationIndexPath.section == 0) {
//            PFUser *user = [self.teamTwoPlayers objectAtIndex:sourceIndexPath.row];
//            [self.teamTwoPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 0 && destinationIndexPath.section == 1) {
//            PFUser *user = [self.currentPlayers objectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.teamTwoPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 2 && destinationIndexPath.section == 0) {
//            PFUser *user = [self.availablePlayers objectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 0 && destinationIndexPath.section == 2) {
//            PFUser *user = [self.currentPlayers objectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 2 && destinationIndexPath.section == 1) {
//            PFUser *user = [self.availablePlayers objectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.teamTwoPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 1 && destinationIndexPath.section == 2) {
//            PFUser *user = [self.teamTwoPlayers objectAtIndex:sourceIndexPath.row];
//            [self.teamTwoPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 1 && destinationIndexPath.section == 1) {
//            PFUser *user = [self.teamTwoPlayers objectAtIndex:sourceIndexPath.row];
//            [self.teamTwoPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.teamTwoPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
//            PFUser *user = [self.currentPlayers objectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.currentPlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//        if (sourceIndexPath.section == 2 && destinationIndexPath.section == 2) {
//            PFUser *user = [self.availablePlayers objectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers removeObjectAtIndex:sourceIndexPath.row];
//            [self.availablePlayers insertObject:user atIndex:destinationIndexPath.row];
//        }
//    }
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone;
    
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - SearchController

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.navigationItem.hidesBackButton = YES;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    NSString *searchText = searchController.searchBar.text;
    if ([searchText isEqualToString:@""]) {
        
        self.availablePlayers = self.searchAvailablePlayers.mutableCopy;
        
        for (PFUser *user in self.currentPlayers) {
            if ([self.availablePlayers containsObject:user]) {
                [self.availablePlayers removeObject:user];
            }
        }
        for (PFUser *user in self.teamTwoPlayers) {
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
    
    self.availablePlayers = self.searchAvailablePlayers.mutableCopy;
    
    for (PFUser *user in self.currentPlayers) {
        if ([self.availablePlayers containsObject:user]) {
            [self.availablePlayers removeObject:user];
        }
    }
    for (PFUser *user in self.teamTwoPlayers) {
        if ([self.availablePlayers containsObject:user]) {
            [self.availablePlayers removeObject:user];
        }
    }
    [self.tableView reloadData];
    self.navigationItem.hidesBackButton = NO;
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


#pragma mark - Other

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
