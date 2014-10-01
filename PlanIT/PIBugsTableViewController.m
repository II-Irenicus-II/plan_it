//
//  BugsTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 09/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIBugsTableViewController.h"

#import "PIAddBugTableViewController.h"
#import "PIDetailedBugTableViewController.h"

#import "PIBugDataController.h"

#import "PITask.h"
#import "PIBug.h"


@interface PIBugsTableViewController () <PIAddBugTableViewControllerDelegate, PIDetailedBugTableViewControllerDelegate>
{
    NSIndexPath* selectedPath;
}

@end

@implementation PIBugsTableViewController

@synthesize dataController = _dataController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataController = [[PIBugDataController alloc] init];
    [_dataController initializeBugListOnComplete:^
    {
        [self.tableView reloadData];
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}




- (void) refreshView
{
    [_dataController initializeBugListOnComplete:^
     {
         [self.tableView reloadData];
         [self.refreshControl endRefreshing];
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataController countOfTaskList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataController countOfBugAtSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = [[_dataController taskInListAtSection:section] name];
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PITask *task = [_dataController taskInListAtSection:indexPath.section];
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:@"bugCell"];
    PIBug* b = [task.bugs objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", b.name, b.priority];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", (long)b.progress];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        [_dataController deleteBugAtRow:indexPath.row AndSection:indexPath.section onSuccess:^
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            [self.tableView reloadData];
        }];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPath = indexPath;
    [self performSegueWithIdentifier:@"detailBugSegue" sender:self];

}


#pragma mark - AddBugTableViewController

- (void) addBugDidCancel:(PIAddBugTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) addBug:(PIBug*) bug withEstimation:(NSString *)estimation DidSuccess:(PIAddBugTableViewController *)controller
{
    
    [_dataController createBugWithName:bug.name
                                  Type:bug.type
                        AssociatedTask:bug.task
                           Responsable:bug.responsable
                               release:bug.released
                        estimationTime:estimation
                           Description:bug.description
                              Priority:bug.priority
                              CallBack:^(PIBug *bug)
    {
        [self dismissViewControllerAnimated:YES completion:^
        {
            [self.dataController addBugToList:bug];
            [self.tableView reloadData];
        }];
    }];
}
- (void) performEdition:(PIDetailedBugTableViewController *)controller onBug:(PIBug*) bug
         withEstimation:(NSString*) estimation
           andSpentTime:(NSString*) spentTime
{
    [_dataController editBugWithID:bug.ID
                              Name:bug.name
                              Type:bug.type
                    AssociatedTask:bug.task
                       Responsable:bug.responsable
                            status:bug.status
                           release:bug.released
                    estimationTime:estimation
                          spentTime:spentTime
                       progression:bug.progress
                       Description:bug.description
                          Priority:bug.priority
                          CallBack:^
    {
        [self.tableView beginUpdates];
        [_dataController deleteBugAtRow:selectedPath.row AndSection:selectedPath.section];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.dataController addBugToList:bug];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addBugSegue"]) {
        PIAddBugTableViewController* ac = (PIAddBugTableViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        ac.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"detailBugSegue"])
    {
        PIDetailedBugTableViewController* dbc = [segue destinationViewController];
        dbc.delegate = self;
        dbc.bug = [[[_dataController taskInListAtSection:selectedPath.section] bugs] objectAtIndex:selectedPath.row];
        dbc.bug.task = [_dataController taskInListAtSection:selectedPath.section];
    }
}


@end
