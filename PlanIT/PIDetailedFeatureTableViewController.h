//
//  DetailedFeatureViewController.h
//  PlanIt
//
//  Created by Irenicus on 28/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIFeature;

@protocol PIDetailedFeatureTableViewControllerDelegate;
@interface PIDetailedFeatureTableViewController : UITableViewController

@property (nonatomic, retain) PIFeature* feature;

@property (nonatomic, retain) id delegate;


@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *releaseField;
@property (weak, nonatomic) IBOutlet UITextField *statusField;
@property (weak, nonatomic) IBOutlet UITextField *responsableField;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UITextField *estimatedField;
@property (weak, nonatomic) IBOutlet UITextField *spentField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;

@property NSInteger estimationTime;
@property NSInteger spentTime;
@property (nonatomic, retain) NSString* description;


- (IBAction)saveAction:(id)sender;

@end


@protocol PIDetailedFeatureTableViewControllerDelegate <NSObject>

- (void) performEdition:(PIDetailedFeatureTableViewController *)controller onFeature:(PIFeature*) Feature
         withEstimation:(NSString*) estimation
           andSpentTime:(NSString*) spentTime;


@end