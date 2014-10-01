//
//  AddUserViewControllerTwo.h
//  PlanIt
//
//  Created by Irenicus on 11/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol PIAddUserSecondViewControllerDelegate;

@class PIUser;
@interface PIAddUserViewTwoController : UITableViewController

@property (nonatomic,retain) id<PIAddUserSecondViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (nonatomic, retain) PIUser* user;

- (IBAction)addNewUser:(id)sender;

@end

@protocol PIAddUserSecondViewControllerDelegate <NSObject>

- (void) addUser:(PIUser*) user DidSucces:(PIAddUserViewTwoController *)controller;

@end
