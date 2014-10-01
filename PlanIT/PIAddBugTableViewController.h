//
//  AddBugTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 17/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PITask, PIBug, PIUser;
@protocol PIAddBugTableViewControllerDelegate;

@interface PIAddBugTableViewController : UITableViewController

@property (nonatomic, retain) id<PIAddBugTableViewControllerDelegate> delegate;

@property (nonatomic, retain) PIBug* bug;

@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *releaseField;
@property (weak, nonatomic) IBOutlet UITextField *responsableField;

@property (weak, nonatomic) IBOutlet UITextField *estimatedField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;

@property NSInteger countdown;


@end


@protocol PIAddBugTableViewControllerDelegate <NSObject>

- (void) addBugDidCancel:(PIAddBugTableViewController *)controller;
- (void) addBug:(PIBug*) bug withEstimation:(NSString*) estimation DidSuccess:(PIAddBugTableViewController *)controller;


@end