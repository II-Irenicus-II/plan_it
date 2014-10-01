//
//  DetailedEventViewController.h
//  PlanIt
//
//  Created by Irenicus on 26/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICalendarViewController.h"
#import "PIDayViewController.h"


@class PIEvent;

@protocol PIDetailedEventViewControllerDelegate;

@interface PIDetailedEventViewController : UITableViewController <UIActionSheetDelegate>


@property (nonatomic, retain) NSDate* date;

@property (nonatomic, retain) id<PIDetailedEventViewControllerDelegate> delegate;

@property (nonatomic, retain) PIEvent* event;
@property (nonatomic, retain) NSString* fromStr;
@property (nonatomic, retain) NSString* toStr;


@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UITextField *eventFromField;
@property (weak, nonatomic) IBOutlet UITextField *eventToField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;



- (IBAction)saveAction:(id)sender;
- (IBAction)removeAction:(id)sender;


@end


@protocol PIDetailedEventViewControllerDelegate <NSObject>

- (void) performEdition:(PIDetailedEventViewController *)controller onEvent:(PIEvent*) event;
- (void) deleteEvent:(PIEvent*) event withController:(PIDetailedEventViewController *)controller;

@end
