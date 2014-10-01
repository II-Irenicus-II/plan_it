//
//  ProjectSelectorController.h
//  PlanIt
//
//  Created by Irenicus on 27/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIProject;
@protocol PIProjectSelectorControllerDelegate;

@interface PIProjectSelectorController : UITableViewController

@property (nonatomic, retain) NSArray* projects;
@property (nonatomic, retain) id<PIProjectSelectorControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@protocol PIProjectSelectorControllerDelegate <NSObject>

- (void) setActiveProject:(PIProject*) project;

@end
