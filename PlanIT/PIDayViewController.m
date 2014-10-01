//
//  DayViewController.m
//  PlanIt
//
//  Created by Irenicus on 16/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//


#import <TapkuLibrary/TapkuLibrary.h>

#import "PIDayViewController.h"

#import "PIAddEventViewController.h"
#import "PIDetailedEventViewController.h"
#import "PIEventDataController.h"

#import "PIEvent.h"

#import "Tools.h"

@interface PIDayViewController ()  <TKCalendarDayViewDataSource, TKCalendarDayViewDelegate, PIAddEventViewControllerDelegate, PIDetailedEventViewControllerDelegate>
{
    PIEvent* lastSelectedEvent;
}
@end

@implementation PIDayViewController

@synthesize dataController = _dataController;
@synthesize delegate = _delegate;

@synthesize dayView = _dayView;
@synthesize events = _events;
@synthesize date = _date;


- (void)viewDidLoad
{
    [super viewDidLoad];
    _dayView = [[TKCalendarDayView alloc] init];
    _dayView.delegate = self;
    _dayView.dataSource = self;
    _dayView.is24hClock = YES;
    [self loadView];
    [self toggleDayView];
}


- (void) loadView
{
    [super loadView];
    
	CGRect applicationFrame = (CGRect)[[UIScreen mainScreen] applicationFrame];
    int dayFrameHeight = applicationFrame.size.height ;
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0,  0, applicationFrame.size.width , dayFrameHeight)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor grayColor];
    
    _dayView.frame = CGRectMake(0, - dayFrameHeight, applicationFrame.size.width, dayFrameHeight);
	[self.view addSubview:_dayView];
    _dayView.date = _date;
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, - 0 / 2, applicationFrame.size.width - 70, 85)];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    self.dateLabel.font = font;
    self.dateLabel.backgroundColor = [UIColor colorWithHex:0 alpha:0];
    [_dayView addSubview:self.dateLabel];
    [self updateDateFormat];
}

- (void) updateDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"ccc d LLLL"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
    NSString* resultDate = [dateFormatter stringFromDate:_date];
    self.dateLabel.text = resultDate;
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    self.title = [dateFormatter stringFromDate:_date];
}

- (void)toggleDayView {
	if (_dayView.frame.origin.y == -_dayView.frame.size.height) {
		// Show
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
		_dayView.frame = CGRectMake(0, 0, _dayView.frame.size.width, _dayView.frame.size.height);
		[UIView commitAnimations];
	} else {
		// Hide
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
		_dayView.frame = CGRectMake(0, -_dayView.frame.size.height, _dayView.frame.size.width, _dayView.frame.size.height);
		[UIView commitAnimations];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSArray *)calendarDayTimelineView:(TKCalendarDayView *)calendarDay eventsForDate:(NSDate *)date
{
	NSDateComponents *info = [_date dateComponentsWithTimeZone:calendarDay.timeZone];
	info.second = 0;
	NSMutableArray *ret = [NSMutableArray array];
	
	for(PIEvent *e in _events){
		
		TKCalendarDayEventView *event = [calendarDay dequeueReusableEventView];
		if(event == nil) event = [TKCalendarDayEventView eventView];
        
		event.identifier = nil;
        event.titleLabel.text = e.title;
		event.startDate = e.start;
		event.endDate = e.end;
        
		[ret addObject:event];
		
	}
	return ret;
}

- (void)calendarDayTimelineView:(TKCalendarDayView *)calendarDay eventViewWasSelected:(TKCalendarDayEventView *)eventView
{
    NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                              NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:eventView.startDate];
    NSInteger evHourBegin = [comp hour];
    NSInteger evMinuteBegin = [comp minute];
    comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                            NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:eventView.endDate];
    NSInteger evHourEnd = [comp hour];
    NSInteger evMinuteEnd = [comp minute];
    
    PIEvent* selectedEvent = nil;
    for (PIEvent* e in _events) {
        comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:e.start];
        NSInteger eHourBegin = [comp hour];
        NSInteger eMinuteBegin = [comp minute];
        comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) fromDate:e.end];
        NSInteger eHourEnd = [comp hour];
        NSInteger eMinuteEnd = [comp minute];
        
        if (eHourBegin == evHourBegin && eMinuteBegin == evMinuteBegin &&
            eHourEnd == evHourEnd && eMinuteEnd == evMinuteEnd &&
            [e.title isEqualToString:eventView.titleLabel.text]) {
            selectedEvent = e;
        }
    }
    
    
    if (selectedEvent != nil) {
        lastSelectedEvent = selectedEvent;
        [self performSegueWithIdentifier:@"detailEventSegue2" sender:self];
    }
}

- (void)calendarDayTimelineView:(TKCalendarDayView *)calendarDay didMoveToDate:(NSDate *)date
{
    self.date = date;
    [self updateDateFormat];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addEventSegue2"]) {
        UINavigationController* nc = (UINavigationController*) segue.destinationViewController;
        PIAddEventViewController* aec = (PIAddEventViewController*) [nc.viewControllers objectAtIndex:0];
        aec.delegate = self;
        [aec setPreferedDate:_date];
    } else if ([segue.identifier isEqualToString:@"detailEventSegue2"])
    {
        PIDetailedEventViewController* dev = [segue destinationViewController];
        dev.event = lastSelectedEvent;
        dev.delegate = self;
    }
}

- (void) refreshEvents
{
    _events = [_dataController refreshEventsFromDate:_date];
    [self.dayView reloadData];
    [_delegate updateCalendar];
}

#pragma mark Add Events Delegate

- (void) addEventDidCancel:(PIAddEventViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) addEvent:(PIEvent*) event DidSuccess:(PIAddEventViewController *)controller
{
    [_dataController createEventWithTitle:event.title StartAt:event.start EndAt:event.end CallBack:^(PIEvent *event) {
        [self dismissViewControllerAnimated:YES completion:^{
            [_dataController addEventToList:event];
            [self refreshEvents];
        }];
    }];
}

#pragma mark Edit Events Delegate


- (void) performEdition:(PIDetailedEventViewController *)controller onEvent:(PIEvent*) event
{
    [_dataController editEventWithID:event.ID Title:event.title StartAt:event.start EndAt:event.end callBack:^
     {
         [self refreshEvents];
         [self.navigationController popViewControllerAnimated:YES];
     }];
}

#pragma mark Delete Events Delegate


- (void) deleteEvent:(PIEvent*) event withController:(PIDetailedEventViewController *)controller
{
    [_dataController deleteEvent:event onSuccess:^
     {
         [self refreshEvents];
         [self.navigationController popViewControllerAnimated:YES];
     }];
}



@end
