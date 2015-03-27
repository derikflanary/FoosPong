//
//  MembersTableViewDataSource.m
//  FoosPong
//
//  Created by Derik Flanary on 3/20/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "MembersTableViewDataSource.h"
#import "NewGameCustomTableViewCell.h"
#import "GroupController.h"
#import "PlayerTableViewCell.h"
#import "EditGroupViewController.h"

@implementation MembersTableViewDataSource


- (void)registerTableView:(UITableView *)tableView {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.groupMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlayerTableViewCell class])];
    if (!cell){
        cell = [PlayerTableViewCell new];
        
    }
    if (self.groupMembers.count > 0) {
        PFUser *user = [self.groupMembers objectAtIndex:indexPath.row];
        if (user == [PFUser currentUser]) {
            cell.detailTextLabel.text = @"Admin";
        }
        cell.textLabel.text = user.username;
    }
    
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return  @"Team Members";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser *user = [self.groupMembers objectAtIndex:indexPath.row];
    if (user == [PFUser currentUser]) {
        return NO;
    }else{
    
    return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PFUser *user = [self.groupMembers objectAtIndex:indexPath.row];

        
        UIAlertController *removePlayerAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Remove %@ From Team?", user.username] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [removePlayerAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [[GroupController sharedInstance]removeUserFromGroup:[self.groupMembers objectAtIndex:indexPath.row] callback:^(BOOL *succeeded) {
                [self.groupMembers removeObject:[self.groupMembers objectAtIndex:indexPath.row]];
                [tableView reloadData];
            }];
        }]];
        [removePlayerAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        EditGroupViewController *egvc = [EditGroupViewController new];
        [egvc presentViewController:removePlayerAlert animated:YES completion:nil];
        
        
    }
}



@end
