//
//  ResponsableTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PIUser, PIUserDataController;
@protocol PIResponsableTableViewControllerDelegate;

@interface PIResponsableTableViewController : UITableViewController

@property (nonatomic, retain) id<PIResponsableTableViewControllerDelegate> delegate;
@property (nonatomic, retain) PIUserDataController* dataController;

@end

@protocol PIResponsableTableViewControllerDelegate <NSObject>

- (void) setActiveUser:(PIUser*) user;

@end