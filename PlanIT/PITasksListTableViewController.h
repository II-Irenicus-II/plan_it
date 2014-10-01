//
//  TasksListTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 16/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PITask, PITaskDataController;
@protocol PITasksListTableViewControllerDelegate <NSObject>

- (void) setActiveTask:(PITask*) task;

@end

@interface PITasksListTableViewController : UITableViewController

@property (nonatomic, retain) PITaskDataController* dataController;

@property (nonatomic, unsafe_unretained) id<PITasksListTableViewControllerDelegate> delegate;

@end
