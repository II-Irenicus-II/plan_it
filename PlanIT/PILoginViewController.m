//
//  LoginViewController.m
//  PlanIt
//
//  Created by Irenicus on 08/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PILoginViewController.h"

#import "Tools.h"

#import "PIClientAPI.h"
#import "PICoreDataController.h"

#import "PICAccount.h"
#import "PICProfile.h"

#import "PIUser.h"
#import "PIProfile.h"

@implementation PILoginViewController
{
    NSFetchRequest* request;
    BOOL accountIsPresent;
    NSString* loginLoaded;
    NSString* passwordLoaded;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self->accountIsPresent = NO;
    self->origin = self.view.frame.origin.y;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    PICAccount* acc =[[PICoreDataController sharedInstance] getLastAccount];
    if (acc) {
        accountIsPresent = YES;
        self.loginTextField.text = acc.login;
        self.passwordTextField.text = acc.password;
        loginLoaded = acc.login;
        passwordLoaded = acc.password;
    }
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self->origin, self.view.frame.size.width, self.view.frame.size.height);
}


- (void) frameDown
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 140, self.view.frame.size.width, self.view.frame.size.height);
    
}

- (void) resignKeyboard:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self frameDown];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyboard];
    return YES;
}



- (IBAction)connect:(id)sender {
    [[PIClientAPI sharedInstance] loginWithParameters:@{@"login" :self.loginTextField.text, @"password" : self.passwordTextField.text}
                                              success:^(AFHTTPRequestOperation* operation, PIUser* userAccount)
     {
         NSLog(@"Authentification : Success");
         if (!accountIsPresent) {
             accountIsPresent= YES;
             [[PICoreDataController sharedInstance] addAccountFromUser:userAccount withPassword:self.passwordTextField.text];
         }
         [self performSegueWithIdentifier:@"homeController" sender:self];
     }
                                              failure:^(AFHTTPRequestOperation* operation, NSError* error)
     {
         if (accountIsPresent) {
             [self performSegueWithIdentifier:@"homeController" sender:self];
         } else {
             [self loginError];
             NSLog(@"Authentification : Failure \n%@",error);
         }
     }];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeController"]) {
        [Tools setActiveProjectCallBack:^(NSMutableArray *projects, PIProject *projectSelected) {}];
    }
}

- (void) loginError
{
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Unable to connect to the server : \n The login or the password provided is not valid or you are not connected"];
}

- (BOOL) userCanLogIn
{
    return accountIsPresent;
}

- (IBAction)loginTouchDown:(id)sender
{
    [self frameDown];
}

- (IBAction)passwordTouchDown:(id)sender
{
    [self frameDown];
}

- (IBAction)passwordEditingDidEnd:(id)sender {
    accountIsPresent = [passwordLoaded isEqualToString:self.passwordTextField.text] &&  [loginLoaded isEqualToString:self.loginTextField.text];

}

- (IBAction)loginEditingDidEnd:(id)sender {
    accountIsPresent = [passwordLoaded isEqualToString:self.passwordTextField.text] &&  [loginLoaded isEqualToString:self.loginTextField.text];
}

@end
