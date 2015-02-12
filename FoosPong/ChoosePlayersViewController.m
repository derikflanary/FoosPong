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


@interface ChoosePlayersViewController ()<UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,strong)ChoosePlayerDatasource *dataSource;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSString *currentUser;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *users;
@property (nonatomic, strong)NSMutableArray *players;
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
    
    PFUser *currentUser = [PFUser currentUser];
    self.currentUser = currentUser.username;
    self.players = [NSMutableArray array];
    [self.players insertObject:currentUser atIndex:0];
    //[self.players insertObject:@"" atIndex:1];
    
    
    UIBarButtonItem * startGameButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Game" style:UIBarButtonItemStylePlain target:self action:@selector(startGame:)];
    self.navigationItem.rightBarButtonItem = startGameButton;
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFUser *object in objects) {
                NSLog(@"%@", object.username);
                
            }
            self.users = objects;
            [self.players addObjectsFromArray:self.users];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    //self.users = query;
    // Do any additional setup after loading the view.
}
-(void)startGame:(id)sender{
    
    
    
    GameViewController *gvc = [GameViewController new];
    NSDictionary *playerOneDict = [self.players objectAtIndex:0];
    NSDictionary *playerTwoDict = [self.players objectAtIndex:1];
    gvc.playerOneName = [NSString stringWithFormat:@"%@", playerOneDict[@"username"]];
    gvc.playerTwoName = [NSString stringWithFormat:@"%@", playerTwoDict[@"username"]];
    [self.navigationController pushViewController:gvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Datasource

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
        return 1;
    }else{
        return [self.users count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    if (indexPath.section == 0 && indexPath.row == 0){
        NSDictionary *playerDict = [self.players objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", playerDict[@"username"]];
    }
//    if (indexPath.section == 0 && indexPath.row == 1){
//        cell.textLabel.text = @"";
//    }
    if (indexPath.section == 1) {
        NSDictionary *playerDict = [self.players objectAtIndex:indexPath.row + 1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", playerDict[@"username"]];
    }
//    if (indexPath.row == 0 && indexPath.section == 0){
//        if (!self.currentUser) {
//            cell.textLabel.text = @"Guest";
//        }
//        cell.textLabel.text = self.currentUser;
//    }else if(indexPath.section == 1){
//        NSDictionary *userDict = [self.users objectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@", userDict[@"username"]];
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
   
    id dataObject = [self.players objectAtIndex:sourceIndexPath.row];
    [self.players removeObjectAtIndex:sourceIndexPath.row];
    [self.players insertObject:dataObject atIndex:destinationIndexPath.row];
    NSLog(@"%@", self.players);

//    NSString *stringToMove = [self.reorderingRows objectAtIndex:sourceIndexPath.row];
//    [self.reorderingRows removeObjectAtIndex:sourceIndexPath.row];
//    [self.reorderingRows insertObject:stringToMove atIndex:destinationIndexPath.row];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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
