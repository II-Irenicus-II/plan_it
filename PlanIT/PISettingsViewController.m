//
//  SettingsViewController.m
//  PlanIt
//
//  Created by Irenicus on 10/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//


#import "PISettingsViewController.h"
#import "PIProjectSelectorController.h"

#import "Tools.h"

#import "PIClientAPI.h"
#import "PICoreDataController.h"

#import "PIProject.h"
#import "PICProject.h"

@implementation PISettingsViewController
@synthesize projects = _projects;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [Tools setActiveProjectCallBack:^(NSMutableArray *projects, PIProject *projectSelected) {
        _projects = projects;
        [self setActiveProject:projectSelected];
        self.selectedLabel.text = projectSelected.name;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"projectSelectorSegue" sender:self];
    }
}

- (void) setActiveProject:(PIProject*) project
{
    PICProject* storeProj = [[PICoreDataController sharedInstance] getLastProject];
    if (storeProj == nil) {
        [[PICoreDataController sharedInstance] addPICProjectFromProject:project];
    } else {
        [[PICoreDataController sharedInstance] clearEntity:@"PICProject"];
        [[PICoreDataController sharedInstance] addPICProjectFromProject:project];
    }
    [[PIClientAPI sharedInstance] setProjectID:project.ID success:^(AFHTTPRequestOperation *operation, PIProject *project) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    self.selectedLabel.text = project.name;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"projectSelectorSegue"]) {
        PIProjectSelectorController* vc = [segue destinationViewController];
        [vc setDelegate:self];
        [vc setProjects:_projects];
    }
}

@end
