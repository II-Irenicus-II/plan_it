//
//  UsersTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 10/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIUsersTableViewController.h"
#import "PIAddUserViewOneController.h"
#import "PIAddUserViewTwoController.h"
#import "PIDetailedUserController.h"
#import "PIUserDataController.h"

#import "PIUser.h"
#import "PIProfile.h"

@interface PIUsersTableViewController () <PIAddUserViewControllerDelegate, PIAddUserSecondViewControllerDelegate, PIEditViewControllerDelegate>
{
    NSInteger selectedRow;
}
@end

@implementation PIUsersTableViewController
@synthesize dataController = _dataController;


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    _dataController = [[PIUserDataController alloc] init];
    [self refreshView];
}

- (void) refreshView
{
    [_dataController initializeUserListOnComplete:^
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
    PIUser* user = [_dataController userInListAtIndex:indexPath.row];
    NSString* profileDescription = user.profile.description;
    static NSString *CellIdentifier;
    if ([profileDescription isEqualToString:@"Developper"]) {
        CellIdentifier = @"developper_cell";
    } else if ([profileDescription isEqualToString:@"Commercial"]){
        CellIdentifier = @"commercial_cell";
    } else {
        CellIdentifier = @"manager_cell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"detailedSegue" sender:self];
}

- (void)     tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        [_dataController deleteUserAtRow:indexPath.row onSuccess:^
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
    if ([[segue identifier] isEqualToString:@"addUserSegue"]) {
        
        PIAddUserViewOneController* au = (PIAddUserViewOneController*)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        au.delegate = self;
        au.secondDelegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"detailedSegue"]) {
        PIDetailedUserController* du = (PIDetailedUserController*)[segue destinationViewController];
        du.user = [_dataController userInListAtIndex:selectedRow];
        du.delegate = self;
    }
}

#pragma Protocol AddUserViewController

- (void) addUserDidCancel:(PIAddUserViewOneController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) addUser:(PIUser*) user DidSucces:(PIAddUserViewTwoController *)controller
{
    [_dataController createUserWithLogin:user.login Password:user.password FirstName:user.firstName LastName:user.lastName EmailAddress:user.emailAddress PhoneNumber:user.phoneNumber ProfileID:user.profile.ID callBack:^{
        [self dismissViewControllerAnimated:YES completion:^
        {
            [self.tableView reloadData];
        }];
    }];
}

#pragma Protocol EditUserViewController

- (void) performEdition:(PIDetailedUserController *)controller onUser:(PIUser*) user
{
    [_dataController editUserWitID:user.ID SetLogin:user.login SetPassword:user.password SetFirstName:user.firstName SetLastName:user.lastName SetEmailAddress:user.emailAddress SetphoneNumber:user.phoneNumber SetProfileID:user.profile.ID callBack:^
    {
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end
