//
//  RoadmapViewController.m
//  PlanIt
//
//  Created by Irenicus on 17/09/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIRoadmapViewController.h"
#import "PITaskDataController.h"
#import "PIDetailedTaskViewController.h"

#import "PIClientAPI.h"

#import "PITask.h"


@interface PIRoadmapViewController () <PIDetailedTaskViewControllerDelegate>
{
    NSInteger selectedRow;
}


- (void) reloadData;

@end

@implementation PIRoadmapViewController
@synthesize dataController = _dataController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.progress = 0;
    _dataController = [[PITaskDataController alloc] init];
    [_dataController initializeRoadmapTaskListOnComplete:^(NSInteger progress) {
        self.progress = progress;
        [self reloadData];
    }];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData
{
    self.percentLabel.text = [NSString stringWithFormat:@"%ld%%",self.progress];
    self.progressView.progress = (float)(self.progress) / 100;
    self.remainingTaksLabel.text = [NSString stringWithFormat:@"%ld tasks", [_dataController countOfList]];
    [self.tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PITask *task = [_dataController taskInListAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"roadmapTaskCell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", task.name, task.priority];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", task.progress];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"detailedTaskSegueFromRoadMap" sender:self];
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
             [self reloadData];
         }];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailedTaskSegueFromRoadMap"])
    {
        PIDetailedTaskViewController* dt = [segue destinationViewController];
        dt.task = [_dataController taskInListAtIndex:selectedRow];
        dt.delegate = self;
    }
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
