//
//  AddUserViewControllerOne.h
//  PlanIt
//
//  Created by Irenicus on 11/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIUser;
@protocol PIAddUserViewControllerDelegate, PIAddUserSecondViewControllerDelegate;
@interface PIAddUserViewOneController : UITableViewController


@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, retain) id<PIAddUserViewControllerDelegate> delegate;
@property (nonatomic, retain) id<PIAddUserSecondViewControllerDelegate> secondDelegate;


@property (nonatomic, retain) NSMutableArray* profiles;
@property (nonatomic, retain) PIUser* user;

@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;



- (IBAction)nextAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end

@protocol PIAddUserViewControllerDelegate <NSObject>

- (void) addUserDidCancel:(PIAddUserViewOneController *)controller;

@end