//
//  CalendarViewController.h
//  PlanIt
//
//  Created by Irenicus on 15/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKCalendarMonthView, PIEventDataController, PIEvent;

@interface PICalendarViewController : UIViewController

@property (nonatomic, retain) PIEventDataController* dataController;
@property (nonatomic, retain) TKCalendarMonthView *calendar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
