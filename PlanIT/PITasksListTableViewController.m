//
//  TasksListTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 16/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PITasksListTableViewController.h"
#import "PITaskDataController.h"

#import "PITask.h"

@interface PITasksListTableViewController ()

@end

@implementation PITasksListTableViewController
@synthesize dataController = _dataController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataController = [[PITaskDataController alloc] init];
    [_dataController initializeTaskListOnComplete:^
    {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PITask *task = [_dataController taskInListAtIndex:indexPath.row];
    cell.textLabel.text = task.name;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate setActiveTask:[_dataController taskInListAtIndex:indexPath.row]];
}

@end
