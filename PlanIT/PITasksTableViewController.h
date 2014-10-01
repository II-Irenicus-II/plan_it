//
//  TasksTableView.h
//  PlanIt
//
//  Created by Irenicus on 27/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PITaskDataController;
@interface PITasksTableViewController : UITableViewController

@property (nonatomic, retain) PITaskDataController* dataController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
