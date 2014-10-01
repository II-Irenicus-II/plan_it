//
//  AddUserViewControllerTwo.m
//  PlanIt
//
//  Created by Irenicus on 11/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIAddUserViewTwoController.h"

#import "PIUser.h"

@implementation PIAddUserViewTwoController 

@synthesize delegate = _delegate;


-(void) viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}



- (IBAction)addNewUser:(id)sender
{
    self.user.emailAddress = self.emailTextField.text;
    self.user.phoneNumber = self.phoneNumberTextField.text;
    self.user.firstName = self.firstnameTextField.text;
    self.user.lastName = self.lastnameTextField.text;
    [_delegate addUser:self.user DidSucces:self];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void) hideKeyboard {
    [self.view endEditing:YES];
}

@end
