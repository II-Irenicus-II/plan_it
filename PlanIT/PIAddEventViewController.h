//
//  AddEventViewController.h
//  PlanIt
//
//  Created by Irenicus on 25/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIAddEventViewControllerDelegate;

@class PIEvent;

@interface PIAddEventViewController : UITableViewController

@property (nonatomic, retain) id<PIAddEventViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) NSDate* preferedDate;

@property (nonatomic, retain) NSString* fromStr;
@property (nonatomic, retain) NSString* toStr;


@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UITextField *eventFromField;
@property (weak, nonatomic) IBOutlet UITextField *eventToField;

- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

- (void) setDatePickerToDate:(NSDate*) date;

@end

@protocol PIAddEventViewControllerDelegate <NSObject>

- (void) addEventDidCancel:(PIAddEventViewController *)controller;
- (void) addEvent:(PIEvent*) event DidSuccess:(PIAddEventViewController *)controller;


@end