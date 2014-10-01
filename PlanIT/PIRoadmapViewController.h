//
//  RoadmapViewController.h
//  PlanIt
//
//  Created by Irenicus on 17/09/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PITask, PITaskDataController;
@interface PIRoadmapViewController : UIViewController

@property (nonatomic, retain) PITaskDataController* dataController;
@property NSInteger progress;

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTaksLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
