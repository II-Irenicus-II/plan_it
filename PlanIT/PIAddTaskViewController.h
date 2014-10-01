//
//  AddTaskController.h
//  PlanIt
//
//  Created by Irenicus on 28/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIAddTaskViewControllerDelegate;

@class PITask;
@interface PIAddTaskViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) id<PIAddTaskViewControllerDelegate> delegate;

@property (nonatomic, retain) PITask* task;

@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmented;
@property (weak, nonatomic) IBOutlet UITextView *textView;


- (IBAction)doneAction:(id)sender;
- (IBAction)cancelAction:(id)sender;


@end

@protocol PIAddTaskViewControllerDelegate <NSObject>

- (void) addTaskDidCancel:(PIAddTaskViewController *)controller;
- (void) addTask:(PITask*) task DidSucces:(PIAddTaskViewController *)controller;

@end