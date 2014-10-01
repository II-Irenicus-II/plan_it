//
//  EditUserRightsController.m
//  PlanIt
//
//  Created by Irenicus on 18/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIUserRightsController.h"

#import "PIClientAPI.h"

@implementation PIUserRightsController
@synthesize delegate = _delegate;
@synthesize profiles = _profiles;

- (void) viewDidLoad
{
    [super viewDidLoad];
    [[PIClientAPI sharedInstance] getProfilesOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *profiles) {
        _profiles = profiles;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.profiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"rightsCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[_profiles objectAtIndex:indexPath.row] description];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate setActiveProfile:[self.profiles objectAtIndex:indexPath.row]];
}

@end
