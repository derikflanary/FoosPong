//
//  ChoosePlayerDatasource.m
//  FoosPong
//
//  Created by Daniel Bladh on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "ChoosePlayerDatasource.h"
#import "NewGameViewController.h"

@interface DXListTableViewDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation ChoosePlayerDatasource



- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Entry *entry = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = entry.title;
    
    return cell;
}









@end
