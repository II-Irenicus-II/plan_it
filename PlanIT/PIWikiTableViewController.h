//
//  WikiTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 06/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIWikiTableViewController : UITableViewController

@property (nonatomic, retain) NSArray* wikiSections;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
