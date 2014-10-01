//
//  BugsTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 09/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIBugDataController;
@interface PIBugsTableViewController : UITableViewController

@property (nonatomic, retain) PIBugDataController* dataController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
