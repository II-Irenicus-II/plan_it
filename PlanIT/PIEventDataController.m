//
//  EventDataController.m
//  PlanIt
//
//  Created by Irenicus on 19/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>

#import "PIEventDataController.h"

#import "PIClientAPI.h"
#import "Tools.h"

#import "PIEvent.h"

@interface PIEventDataController ()

@end

@implementation PIEventDataController
@synthesize events = _events;
@synthesize tableViewEvents = _tableViewEvents;
@synthesize marks = _marks;

- (id)init
{
    self = [super init];
    if (self) {
        _events = [[NSMutableArray alloc] init];
        _tableViewEvents = [[NSMutableArray alloc] init];
        _marks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initializeEventListOnComplete:(void(^)(void))complete
{
    [[PIClientAPI sharedInstance] getEventsOnSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *events) {
        _events = events;
        _tableViewEvents = [self refreshEventsFromDate:[NSDate date]];
        complete();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark TKCalendarMonthViewDataSource methods
- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
    NSMutableArray* dates = [[NSMutableArray alloc] init];
    for (PIEvent* e in _events) {
        NSDate *start = [Tools dateFormatedToCalendarFromDate:e.start];
        NSDate *end = [Tools dateFormatedToCalendarFromDate:e.end];
        if ([start isEqualToDate:end]) {
            [dates addObject:start];
        } else {
            [dates addObject:end];
        }
    }
	self.marks = [NSMutableArray array];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                              NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit)
                                    fromDate:startDate];
    [comp setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
	NSDate *d = [cal dateFromComponents:comp];
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];
	while (YES) {
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
        NSDate* keyDate = [Tools dateFormatedToCalendarFromDate:d];
		if ([dates containsObject:keyDate]) {
			[self.marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[self.marks addObject:[NSNumber numberWithBool:NO]];
		}
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	return [NSArray arrayWithArray:self.marks];

}


- (NSMutableArray*) refreshEventsFromDate: (NSDate*) date
{
    NSMutableArray * mu = [[NSMutableArray alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                              NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    NSInteger selectedDateDay = [comp day];
    NSInteger selectedDateMonth = [comp month];
    NSInteger selectedDateYear = [comp year];
    NSInteger eventDateDay = 0;
    NSInteger eventDateMonth = 0;
    NSInteger eventDateYear = 0;
    
    for (PIEvent* e in _events) {
        comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:[Tools dateFormatedToCalendarFromDate:e.start]];
        eventDateDay = comp.day;
        eventDateMonth = [comp month];
        eventDateYear = [comp year];
        if (eventDateDay >= selectedDateDay && eventDateMonth >= selectedDateMonth && eventDateYear >= selectedDateYear) {
            [mu addObject:e];
        }
    }
    return mu;
}





- (NSInteger)countOfList
{
    return [_tableViewEvents count];
}

- (PIEvent*)eventInListAtIndex:(NSInteger)index
{
    return [_tableViewEvents objectAtIndex:index];
}


- (void) createEventWithTitle:(NSString *)title
                      StartAt:(NSDate *)start
                        EndAt:(NSDate *)end
                     CallBack:(void (^)(PIEvent *))callback
{
    NSDictionary* eventDic = @{ @"event" :
                                   @{
                                       @"title" : title,
                                       @"start" : start,
                                       @"end" : end
                                    }
                               };
    [[PIClientAPI sharedInstance] createEvent:eventDic success:^(AFHTTPRequestOperation *operation, PIEvent *event) {
        callback(event);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void) addEventToList: (PIEvent*) event
{
    [_tableViewEvents addObject:event];
    [_events addObject:event];
    [self refreshEventsFromDate:[NSDate date]];
}

- (void) replaceEventAtIndex: (NSInteger) row byEvent: (PIEvent*) event
{
    [_tableViewEvents replaceObjectAtIndex:row withObject:event];
}

- (void)editEventWithID:(NSInteger) ID
                  Title:(NSString*) title
                StartAt:(NSDate*) start
                  EndAt:(NSDate*) end
               callBack:(void(^)(void))callback
{
    NSDictionary* eventDic = @{ @"event" :
                                    @{
                                        @"title" : title,
                                        @"start" : start,
                                        @"end" : end
                                        }
                                };
    [[PIClientAPI sharedInstance] editEvent:ID parameters:eventDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (PIEvent* ev in _events) {
            if (ev.ID == ID) {
                ev.title = title;
                ev.start = start;
                ev.end = end;
            }
        }
        for (PIEvent* ev in _tableViewEvents) {
            if (ev.ID == ID) {
                ev.title = title;
                ev.start = start;
                ev.end = end;
            }
        }
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) deleteEvent: (PIEvent*) event onSuccess:(void(^)(void))callback
{
    [[PIClientAPI sharedInstance] deleteEvent:event.ID success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [_events removeObject:event];
         [_tableViewEvents removeObject:event];
         callback();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}

- (void) deleteEventAtRow:(NSInteger) row onSuccess:(void(^)(void))callback
{
    PIEvent* ev = [self eventInListAtIndex:row];
    [[PIClientAPI sharedInstance] deleteEvent:ev.ID success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [_events removeObject:ev];
         [_tableViewEvents removeObjectAtIndex:row];
         callback();
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}


#pragma mark Data Controller Helpers

- (BOOL) dateIsToday: (NSDate*) date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                              NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    NSInteger paramDateDay = [comp day];
    
    comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                            NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    NSInteger today = [comp day];
    return (today == paramDateDay);
}



@end
