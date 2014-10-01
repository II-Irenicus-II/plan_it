//
//  UsersTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 10/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIUserDataController;
@interface PIUsersTableViewController : UITableViewController 

@property (strong, nonatomic) PIUserDataController *dataController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
