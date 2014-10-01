//
//  FeatureTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 28/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIFeaturesTableViewController.h"
#import "PIFeatureDataController.h"

#import "PIAddFeatureTableViewController.h"
#import "PIDetailedFeatureTableViewController.h"

#import "PITask.h"
#import "PIFeature.h"

@interface PIFeaturesTableViewController () <PIAddFeatureTableViewControllerDelegate>
{
    NSIndexPath* selectedPath;
}

@end

@implementation PIFeaturesTableViewController


@synthesize dataController = _dataController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_dataController == nil) {
        _dataController = [[PIFeatureDataController alloc] init];
        [_dataController initializeFeatureListOnComplete:^
         {
             [self.tableView reloadData];
         }];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void) refreshView
{
    [_dataController initializeFeatureListOnComplete:^
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
    return [_dataController countOfFeatureAtSection:section];
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
                             dequeueReusableCellWithIdentifier:@"featureCell"];
    PIFeature* b = [task.features objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", b.name, b.priority];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld%%", (long)b.progress];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        [_dataController deleteFeatureAtRow:indexPath.row AndSection:indexPath.section onSuccess:^
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
    [self performSegueWithIdentifier:@"detailFeatureSegue" sender:self];
    
}


#pragma mark - AddFeatureTableViewController

- (void) addFeatureDidCancel:(PIAddFeatureTableViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) addFeature:(PIFeature*) feature withEstimation:(NSString *)estimation DidSuccess:(PIAddFeatureTableViewController *)controller
{
    
    [_dataController createFeatureWithName:feature.name
                                  Type:feature.type
                        AssociatedTask:feature.task
                           Responsable:feature.responsable
                               release:feature.released
                        estimationTime:estimation
                           Description:feature.description
                              Priority:feature.priority
                              CallBack:^(PIFeature *feature)
     {
         [self dismissViewControllerAnimated:YES completion:^
          {
              [self.dataController addFeatureToList:feature];
              [self.tableView reloadData];
          }];
     }];
}
- (void) performEdition:(PIDetailedFeatureTableViewController *)controller onFeature:(PIFeature*) feature
         withEstimation:(NSString*) estimation
           andSpentTime:(NSString*) spentTime
{
    [_dataController editFeatureWithID:feature.ID
                              Name:feature.name
                              Type:feature.type
                    AssociatedTask:feature.task
                       Responsable:feature.responsable
                            status:feature.status
                           release:feature.released
                    estimationTime:estimation
                         spentTime:spentTime
                       progression:feature.progress
                       Description:feature.description
                          Priority:feature.priority
                          CallBack:^
     {
         [self.tableView beginUpdates];
         [_dataController deleteFeatureAtRow:selectedPath.row AndSection:selectedPath.section];
         [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedPath]
                               withRowAnimation:UITableViewRowAnimationFade];
         [self.tableView endUpdates];
         [self.dataController addFeatureToList:feature];
         [self.tableView reloadData];
         [self.navigationController popViewControllerAnimated:YES];
     }];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addFeatureSegue"]) {
        PIAddFeatureTableViewController* ac = (PIAddFeatureTableViewController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        ac.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"detailFeatureSegue"])
    {
        PIDetailedFeatureTableViewController* dbc = [segue destinationViewController];
        dbc.delegate = self;
        dbc.feature = [[[_dataController taskInListAtSection:selectedPath.section] features] objectAtIndex:selectedPath.row];
        dbc.feature.task = [_dataController taskInListAtSection:selectedPath.section];
    }
}

@end
