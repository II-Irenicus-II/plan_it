//
//  DetailedUserController.m
//  PlanIt
//
//  Created by Irenicus on 18/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIDetailedUserController.h"
#import "PIUsersTableViewController.h"
#import "PIUserRightsController.h"


#import "PIUser.h"
#import "PIProfile.h"

@interface PIDetailedUserController () <PIUserRightsControllerDelegate>
{
    BOOL canEdit;

}
- (void) setRightsForUser;

@end

@implementation PIDetailedUserController
@synthesize user = _user;
@synthesize delegate = _delegate;

-(void) viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self->canEdit = YES;
    if ([_user.profile.description isEqualToString:@"Administrator"]) {
        self->canEdit = YES;
    }
    [self.userField setText:self.user.login];
    [self.firstnameField setText:self.user.firstName];
    [self.lastNameField setText:self.user.lastName];
    [self.phoneNumberField setText:self.user.phoneNumber];
    [self.emailField setText:self.user.emailAddress];
    [self.userRights setText:self.user.profile.description];
    [self setRightsForUser];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) setRightsForUser
{
    if (self->canEdit) {
        [self.userField setEnabled:YES];
        [self.firstnameField setEnabled:YES];
        [self.lastNameField setEnabled:YES];
        [self.phoneNumberField setEnabled:YES];
        [self.emailField setEnabled:YES];
    }
}



- (IBAction)editAction:(id)sender {
    _user.login = self.userField.text;
    _user.firstName = self.firstnameField.text;
    _user.lastName = self.lastNameField.text;
    _user.phoneNumber = self.phoneNumberField.text;
    _user.emailAddress = self.emailField.text;
    [_delegate performEdition:self onUser:self.user];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && canEdit) {
        [self performSegueWithIdentifier:@"userRightsSegue" sender:self];
    }
}


- (void) setActiveProfile:(PIProfile*) profile
{
    _user.profile = profile;
    self.userRights.text = profile.description;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"userRightsSegue"]) {
        PIUserRightsController* ur = (PIUserRightsController*)[segue destinationViewController];
        ur.delegate = self;
    }
}


@end
