//
//  AddUserViewControllerOne.m
//  PlanIt
//
//  Created by Irenicus on 11/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIUsersTableViewController.h"
#import "PIAddUserViewOneController.h"
#import "PIAddUserViewTwoController.h"


#import "PIClientAPI.h"

#import "PIUser.h"

@implementation PIAddUserViewOneController

@synthesize delegate = _delegate;
@synthesize profiles = _profiles;
@synthesize user = _user;


- (void) viewDidLoad
{
    _user = [[PIUser alloc] init];
    _profiles = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];


    [[PIClientAPI sharedInstance] getProfilesOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *profiles) {
        _profiles = profiles;
        _user.profile = [_profiles firstObject];
        [self.pickerView reloadAllComponents];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}


- (void) hideKeyboard {
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)nextAction:(id)sender {
    __block BOOL willContinue = YES;
    if (self.passwordField.text.length < 4) {
        willContinue = NO;
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Password is too short (less than 4 characters) !"];
    }
    if (self.loginField.text.length == 0) {
        willContinue = NO;
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must enter a login !"];
    }
    
    [[PIClientAPI sharedInstance] getUsersOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *users) {
        for (PIUser* user in users) {
            if ([user.login isEqualToString:self.loginField.text]) {
                willContinue =  NO;
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"This login already exists !"];
                break;
            }
        }
        if (willContinue) {
            [self performSegueWithIdentifier:@"nextSegue" sender:self];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}



- (IBAction)cancelAction:(id)sender {
    [_delegate addUserDidCancel:self];
}


#pragma mark delegate / dataSource for pickerView

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _user.profile = [_profiles objectAtIndex:row];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_profiles count];
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[_profiles objectAtIndex:row] description];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"nextSegue"])
    {
        PIAddUserViewTwoController *sec = (PIAddUserViewTwoController *)[segue destinationViewController];
        _user.login = self.loginField.text;
        _user.password = self.passwordField.text;
        sec.user = _user;
        sec.delegate = self.secondDelegate;
    }
}




@end