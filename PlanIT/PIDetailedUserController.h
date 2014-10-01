//
//  DetailedUserController.h
//  PlanIt
//
//  Created by Irenicus on 18/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PIUser, PIProfile;

@protocol PIEditViewControllerDelegate;
@interface PIDetailedUserController : UITableViewController


@property (nonatomic, retain) id <PIEditViewControllerDelegate> delegate;
@property (nonatomic, retain) PIUser* user;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *userRights;


- (void) setActiveProfile:(PIProfile*) profile;


@end

@protocol PIEditViewControllerDelegate <NSObject>

- (void) performEdition:(PIDetailedUserController *)controller onUser:(PIUser*) user;

@end
