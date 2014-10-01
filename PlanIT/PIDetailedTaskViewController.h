//
//  DetailedViewController.h
//  PlanIt
//
//  Created by Irenicus on 28/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIDetailedTaskViewControllerDelegate;

@class PITask;

@interface PIDetailedTaskViewController : UIViewController


@property (nonatomic, retain) id<PIDetailedTaskViewControllerDelegate> delegate;

@property (nonatomic, retain) PITask* task;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmented;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;

- (IBAction)saveAction:(id)sender;


- (IBAction)featuresAction:(id)sender;

@end


@protocol PIDetailedTaskViewControllerDelegate <NSObject>

- (void) performEdition:(PIDetailedTaskViewController *)controller onTask:(PITask*) task;

@end
