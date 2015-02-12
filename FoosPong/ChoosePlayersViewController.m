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
@end

@implementation ChoosePlayersViewController



- (void)viewDidLoad {
        [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    PFUser *currentUser = [PFUser currentUser];
    self.currentUser = currentUser.username;
    
    
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
    [self.navigationController pushViewController:[GameViewController new] animated:YES];
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
        return 2;
    }else{
        return [self.users count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    if (indexPath.row == 0 && indexPath.section == 0){
        cell.textLabel.text = self.currentUser;
    }else if(indexPath.section == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.users objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
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
