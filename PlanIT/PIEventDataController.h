//
//  EventDataController.h
//  PlanIt
//
//  Created by Irenicus on 19/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIEvent,TKCalendarMonthView;

@interface PIEventDataController : NSObject  <TKCalendarMonthViewDataSource>

@property (nonatomic, retain) NSMutableArray* events;
@property (nonatomic, retain) NSMutableArray* marks;
@property (nonatomic, retain) NSMutableArray* tableViewEvents;

- (void)initializeEventListOnComplete:(void(^)(void))complete;

- (NSInteger)countOfList;

- (PIEvent*)eventInListAtIndex:(NSInteger)index;

- (NSMutableArray*) refreshEventsFromDate: (NSDate*) date;

- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate;



- (void)createEventWithTitle:(NSString*) title
               StartAt:(NSDate*) start
                  EndAt:(NSDate*) end
                  CallBack:(void(^)(PIEvent* event))callback;

- (void) addEventToList: (PIEvent*) event;

- (void) replaceEventAtIndex: (NSInteger) row byEvent: (PIEvent*) event;


- (void)editEventWithID:(NSInteger) ID
                  Title:(NSString*) title
                StartAt:(NSDate*) start
                  EndAt:(NSDate*) end
              callBack:(void(^)(void))callback;


- (void) deleteEvent: (PIEvent*) event onSuccess:(void(^)(void))callback;

- (void) deleteEventAtRow:(NSInteger) row onSuccess:(void(^)(void))callback;


@end
