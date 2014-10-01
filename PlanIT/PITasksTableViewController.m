//
//  TasksTableView.m
//  PlanIt
//
//  Created by Irenicus on 27/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PITasksTableViewController.h"
#import "PITaskDataController.h"
#import "PIAddTaskViewController.h"
#import "PIDetailedTaskViewController.h"

#import "PITask.h"


@interface PITasksTableViewController () <PIAddTaskViewControllerDelegate, PIDetailedTaskViewControllerDelegate>
{
    NSInteger selectedRow;
}
@end

@implementation PITasksTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    _dataController = [[PITaskDataController alloc] init];
    [self refreshView];
}

- (void) refreshView
{
    [_dataController initializeTaskListOnComplete:^
     {
         [self.tableView reloadData];
         [self.refreshControl endRefreshing];
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
    PITask *task = [_dataController taskInListAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:@"taskCell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", task.name, task.priority];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", (long)task.progress];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"detailedTaskSegue" sender:self];
}

- (void)     tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        [_dataController deleteTaskAtRow:indexPath.row onSuccess:^
         {
             [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
             [tableView endUpdates];
             [self.tableView reloadData];
             
         }];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addTaskSegue"]) {
        PIAddTaskViewController* at = (PIAddTaskViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        at.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"detailedTaskSegue"])
    {
        PIDetailedTaskViewController* dt = [segue destinationViewController];
        dt.task = [_dataController taskInListAtIndex:selectedRow];
        dt.delegate = self;
    }
}

#pragma mark - Protocol AddTaskViewControllerDelegate

- (void) addTaskDidCancel:(PIAddTaskViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) addTask:(PITask*) task DidSucces:(PIAddTaskViewController *)controller
{
    [_dataController createTaskWithName:task.name Description:task.description Priority:task.priority CallBack:^(PITask *responseTask) {
        [self dismissViewControllerAnimated:YES completion:^
         {
             [self.dataController addTaskToList:responseTask];
             [self.tableView reloadData];
         }];
    }];
}

#pragma mark - Protocol PIDetailedTaskViewController


- (void) performEdition:(PIDetailedTaskViewController *)controller onTask:(PITask*) task;
{
    [_dataController editTaskWithID:task.ID Name:task.name Description:task.description Priority:task.priority callBack:^
    {
        [self.dataController replaceTaskAtIndex:selectedRow byTask:task];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
