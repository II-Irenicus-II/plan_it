//
//  DayViewController.h
//  PlanIt
//
//  Created by Irenicus on 16/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKCalendarDayView, PIEventDataController;
@protocol PIDayViewControllerDelegate;
@interface PIDayViewController : UIViewController

@property (nonatomic, retain) id<PIDayViewControllerDelegate> delegate;

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) PIEventDataController* dataController;

@property (nonatomic, retain) TKCalendarDayView* dayView;
@property (nonatomic, retain) NSMutableArray* events;

@property (nonatomic, retain) UILabel* dateLabel;

@end

@protocol PIDayViewControllerDelegate <NSObject>

- (void) updateCalendar;

@end
