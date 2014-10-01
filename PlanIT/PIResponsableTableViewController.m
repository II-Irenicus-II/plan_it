//
//  ResponsableTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIResponsableTableViewController.h"

#import  "PIUserDataController.h"

#import "PIUser.h"

@implementation PIResponsableTableViewController
@synthesize delegate = _delegate;
@synthesize dataController = _dataController;

- (void) viewDidLoad
{
    [super viewDidLoad];
    _dataController = [[PIUserDataController alloc] init];
    [_dataController initializeUserListOnComplete:^
    {
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIUser *user = [_dataController userInListAtIndex: indexPath.row];

    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:@"ResponsableCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PIUser* activeUser = [_dataController userInListAtIndex:indexPath.row];
    [self.delegate setActiveUser:activeUser];
}

@end
