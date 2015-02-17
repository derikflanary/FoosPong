//
//  HistoryViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "NewGameCustomTableViewCell.h"
#import "HistoryViewController.h"
#import "GameController.h"
#import "UserController.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *games;


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
//    PFUser *currentUser = [UserController sharedInstance].theCurrentUser;
////    [[GameController sharedInstance] updateGamesForUser:currentUser];
//
//    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
//    [query whereKey:@"playerOne" equalTo:[NSString stringWithFormat:@"%@", currentUser.username]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            
//            self.games = objects;
//            [self.tableView reloadData];
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];

    [self getTheGames:^{
        self.games = [GameController sharedInstance].games;
        [self.tableView reloadData];
    }];
}

-(void)getTheGames:(dispatch_block_t)block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PFUser *currentUser = [UserController sharedInstance].theCurrentUser;
        [[GameController sharedInstance] updateGamesForUser:currentUser];
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.games count];
    //return  [[GameController sharedInstance].games count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    //PFObject *game = [[GameController sharedInstance].games objectAtIndex:indexPath.row];
    PFObject *game = [self.games objectAtIndex:indexPath.row];
    cell.textLabel.text = game[@"playerOne"];
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
