//
//  LoginViewController.h
//  PlanIt
//
//  Created by Irenicus on 08/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary.h>

@interface PILoginViewController : UIViewController
{
    NSInteger origin;
}

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)connect:(id)sender;
- (IBAction)loginTouchDown:(id)sender;
- (IBAction)passwordTouchDown:(id)sender;
- (BOOL) userCanLogIn;

@end
