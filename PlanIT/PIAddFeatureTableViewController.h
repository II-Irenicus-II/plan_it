//
//  AddFeatureTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 18/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIDescriptionViewController.h"
#import "PIResponsableTableViewController.h"

@protocol PIAddFeatureTableViewControllerDelegate;
@class PIUser, PITask, PIFeature;

@interface PIAddFeatureTableViewController : UITableViewController <PIResponsableTableViewControllerDelegate, PIDescriptionViewControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) id<PIAddFeatureTableViewControllerDelegate> delegate;

@property (nonatomic, retain) PIFeature* feature;


@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *releaseField;
@property (weak, nonatomic) IBOutlet UITextField *responsableField;
@property (weak, nonatomic) IBOutlet UITextField *estimatedField;


@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;

@property NSInteger countdown;

- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;


@end
@protocol PIAddFeatureTableViewControllerDelegate <NSObject>

- (void) addFeatureDidCancel:(PIAddFeatureTableViewController *)controller;
- (void) addFeature:(PIFeature*) feature withEstimation:(NSString*) estimation DidSuccess:(PIAddFeatureTableViewController*)controller;


@end

