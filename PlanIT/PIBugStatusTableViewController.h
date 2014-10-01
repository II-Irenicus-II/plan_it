//
//  StatusTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIBugStatusTableViewControllerDelegate;

@interface PIBugStatusTableViewController : UITableViewController

@property (nonatomic, retain) id<PIBugStatusTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *notStartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *inProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *closedLabel;
@property (weak, nonatomic) IBOutlet UILabel *resolvedLabel;

@end


@protocol PIBugStatusTableViewControllerDelegate <NSObject>

- (void) setActiveStatus:(NSString*) status;

@end