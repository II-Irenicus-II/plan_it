//
//  FeatureTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 28/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIFeatureDataController;
@interface PIFeaturesTableViewController : UITableViewController

@property (nonatomic, retain)  PIFeatureDataController* dataController;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
