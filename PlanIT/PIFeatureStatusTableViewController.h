//
//  StatusTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIFeatureStatusTableViewControllerDelegate;

@interface PIFeatureStatusTableViewController : UITableViewController

@property (nonatomic, retain) id<PIFeatureStatusTableViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *notStartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *startedLabel;
@property (weak, nonatomic) IBOutlet UILabel *inProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptedLabel;

@end


@protocol PIFeatureStatusTableViewControllerDelegate <NSObject>

- (void) setActiveStatus:(NSString*) status;

@end