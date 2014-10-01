//
//  CalendarViewController.m
//  PlanIt
//
//  Created by Irenicus on 15/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>

#import "PICalendarViewController.h"
#import "PIDayViewController.h"

#import "PIEventDataController.h"
#import "PIAddEventViewController.h"
#import "PIDetailedEventViewController.h"
#import "Tools.h"

#import "PIEvent.h"

@interface PICalendarViewController ()  <TKCalendarMonthViewDelegate, UITableViewDataSource, UITableViewDelegate, PIAddEventViewControllerDelegate, PIDetailedEventViewControllerDelegate, PIDayViewControllerDelegate>
{
    NSDate* lastSelectedDate;
    NSMutableArray* eventsOfTheDay;
    PIEvent* lastSelectedEvent;
}
@end

@implementation PICalendarViewController

@synthesize dataController = _dataController;
@synthesize calendar = _calendar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCalendar];
    [self toggleCalendar];
    
    lastSelectedDate = [NSDate date];
    eventsOfTheDay = [[NSMutableArray alloc] init];
}

- (void) loadCalendar
{
    _dataController = [[PIEventDataController alloc] init];
    _calendar = [[TKCalendarMonthView alloc] init];
    _calendar.delegate = self;
    _calendar.dataSource = _dataController;
    _calendar.frame = CGRectMake(0, -_calendar.frame.size.height, _calendar.frame.size.width, _calendar.frame.size.height);
    UIScrollView* sv = [self.view.subviews objectAtIndex:0];
	[sv addSubview:_calendar];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [_dataController initializeEventListOnComplete:^{
        [self.calendar reloadData];
        [self.tableView reloadData];
        
    }];
}


// Show/Hide the calendar by sliding it down/up from the top of the device.

- (void)toggleCalendar {
	// If calendar is off the screen, show it, else hide it (both with animations)
	if (_calendar.frame.origin.y == -_calendar.frame.size.height) {
		// Show
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
		_calendar.frame = CGRectMake(0, 0, _calendar.frame.size.width, _calendar.frame.size.height);
		[UIView commitAnimations];
	} else {
		// Hide
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
		_calendar.frame = CGRectMake(0, -_calendar.frame.size.height, _calendar.frame.size.width, _calendar.frame.size.height);
		[UIView commitAnimations];
	}
}

#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
    lastSelectedDate = d;
    eventsOfTheDay = [_dataController refreshEventsFromDate:d];
    [self performSegueWithIdentifier:@"loadDayViewSegue" sender:self];
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
    
}



#pragma mark Rotation

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark TableView

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataController countOfList];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"calendarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PIEvent* e = [_dataController eventInListAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM HH'h'mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Paris"]];
    NSString* resultDate = [dateFormatter stringFromDate:e.start];
    cell.textLabel.text = e.title;
    cell.detailTextLabel.text = resultDate;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lastSelectedEvent = [_dataController eventInListAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailEventSegue" sender:self];
}

- (void)     tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [tableView beginUpdates];
        [_dataController deleteEventAtRow:indexPath.row onSuccess:^
         {
             [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
             [tableView endUpdates];
             [self updateCalendar];
         }];
    }
    [self.tableView reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"loadDayViewSegue"])
    {
        PIDayViewController* dvc = [segue destinationViewController];
        dvc.date = lastSelectedDate;
        dvc.events = eventsOfTheDay;
        dvc.dataController = _dataController;
        dvc.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"addEventSegue"])
    {
        PIAddEventViewController* aec = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        aec.delegate = self;
        [aec setDatePickerToDate:[NSDate date]];
    } else if ([[segue identifier] isEqualToString:@"detailEventSegue"])
    {
        PIDetailedEventViewController* dev = [segue destinationViewController];
        dev.event = lastSelectedEvent;
        dev.delegate = self;
    }
    
    
}

#pragma mark PIAddEventViewControllerDelegate


- (void) addEventDidCancel:(PIAddEventViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) addEvent:(PIEvent*) event DidSuccess:(PIAddEventViewController *)controller
{
    [_dataController createEventWithTitle:event.title StartAt:event.start EndAt:event.end CallBack:^(PIEvent *event) {
       [self dismissViewControllerAnimated:YES completion:^{
           [_dataController addEventToList:event];
           [self updateCalendar];
       }];
    }];
}

#pragma mark PIDetailedEventViewControllerDelegate

- (void) performEdition:(PIDetailedEventViewController *)controller onEvent:(PIEvent*) event
{
    [_dataController editEventWithID:event.ID Title:event.title StartAt:event.start EndAt:event.end callBack:^
    {
        [self updateCalendar];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void) deleteEvent:(PIEvent*) event withController:(PIDetailedEventViewController *)controller
{
    [_dataController deleteEvent:event onSuccess:^
    {
        [self updateCalendar];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark PIDayViewControllerDelegate

- (void) updateCalendar
{
    [self.tableView reloadData];
    [self.calendar reloadData];
}



@end
