//
//  ProjectSelectorController.m
//  PlanIt
//
//  Created by Irenicus on 27/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIProjectSelectorController.h"

#import "PIProject.h"


@implementation PIProjectSelectorController

@synthesize delegate = _delegate;
@synthesize projects = _projects;

- (void) viewDidLoad
{
    [super viewDidLoad];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIProject *project = [_projects objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView
                      dequeueReusableCellWithIdentifier:@"projectCell"];
    
    cell.textLabel.text = project.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PIProject* activeProject = [_projects objectAtIndex:indexPath.row];
    [_delegate setActiveProject:activeProject];
}
@end
