//
//  CreateMemberViewController.m
//  FoosPong
//
//  Created by Derik Flanary on 3/18/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "CreateMemberViewController.h"
#import "NewGameCustomTableViewCell.h"
#import "UserController.h"


@interface CreateMemberViewController ()<UITableViewDataSource, UITableViewDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) UIButton *saveNewMembersButton;
@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation CreateMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddressBook)];
    
    self.navigationItem.rightBarButtonItem = addButton;

    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 400) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = NO;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor transparentWhite];
    [self.view addSubview:self.tableView];
    
    self.saveNewMembersButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 400, 320, 41)];
    self.saveNewMembersButton.backgroundColor = [UIColor darkColor];
    self.saveNewMembersButton.titleLabel.font = [UIFont fontWithName:[NSString boldFont] size:20.0f];
    [self.saveNewMembersButton setTitle:@"Save Guest Member" forState:UIControlStateNormal];
    [self.saveNewMembersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveNewMembersButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.saveNewMembersButton addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.contacts = [NSMutableArray array];
    //[self.view addSubview:self.saveNewMembersButton];
    //self.saveNewMembersButton.enabled = NO;

    // Do any additional setup after loading the view.
}

- (void)savePressed:(id)sender{
    [[UserController sharedInstance]addGuestUserWithArray:self.contacts];
}

- (void)showAddressBook{
    
    self.addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [self.addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:self.addressBookController animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.contacts count] > 0) {
        [self.view addSubview:self.saveNewMembersButton];
    }
    return [self.contacts count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewGameCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewGameCell" ];
    if (!cell){
        cell = [NewGameCustomTableViewCell new];
    }
    
    NSDictionary *dict = [self.contacts objectAtIndex:indexPath.row];
    cell.textLabel.text = dict[@"firstName"];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.addressBookController dismissViewControllerAnimated:YES completion:nil];
}


-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"", @"", @""]
                                            forKeys:@[@"firstName", @"lastName", @"email"]];
    
    CFTypeRef generalCFObject;
    generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    generalCFObject = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"email"];
        CFRelease(generalCFObject);
    }
    
    [self.contacts addObject:contactInfoDict];
    [self.tableView reloadData];
    [self.addressBookController dismissViewControllerAnimated:YES completion:nil];
    [self.view addSubview:self.saveNewMembersButton];

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
