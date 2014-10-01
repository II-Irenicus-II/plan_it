//
//  DetailedEventViewController.m
//  PlanIt
//
//  Created by Irenicus on 26/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIDetailedEventViewController.h"

#import "PIEvent.h"

@interface PIDetailedEventViewController ()

@end

@implementation PIDetailedEventViewController
@synthesize event = _event;
@synthesize date = _date;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.eventTitle.text = _event.title;
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    NSLocale *twentyFour = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [outputFormatter setLocale:twentyFour];
    [outputFormatter setDateFormat:@"HH'h'mm"];
    self.eventFromField.text = [outputFormatter stringFromDate:_event.start];
    self.eventToField.text = [outputFormatter stringFromDate:_event.end];
    [outputFormatter setDateFormat:@"HH:mm"];
    self.fromStr = [outputFormatter stringFromDate:_event.start];
    self.toStr = [outputFormatter stringFromDate:_event.end];
    [outputFormatter setDateFormat:@"dd/MM/YYYY"];
    _date = _event.start;

    self.title = [outputFormatter stringFromDate:_event.start];

}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



#pragma mark - Table view delegate

- (void) actionSheetDatePickerWithTitle: (NSString*) title
                                 andTag: (NSInteger) tag
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Done"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet setTag:tag];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,100, 320, 216)];
    NSLocale* local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [datePicker setLocale:local];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [actionSheet addSubview:datePicker];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet setBounds:CGRectMake(0,0, 320, 411)];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH'h'mm"];
    switch (actionSheet.tag) {
        case 1:
        {
            UIDatePicker* datePicker = [actionSheet.subviews objectAtIndex:3];
            self.eventFromField.text = [outputFormatter stringFromDate:datePicker.date];
            [outputFormatter setDateFormat:@"HH:mm"];
            self.fromStr = [outputFormatter stringFromDate:datePicker.date];
        }
            break;
        case 2:
        {
            UIDatePicker* datePicker = [actionSheet.subviews objectAtIndex:3];
            self.eventToField.text = [outputFormatter stringFromDate:datePicker.date];
            [outputFormatter setDateFormat:@"HH:mm"];
            self.toStr = [outputFormatter stringFromDate:datePicker.date];
        }
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self actionSheetDatePickerWithTitle:@"From" andTag:1];
        } else if (indexPath.row == 1)
        {
            [self actionSheetDatePickerWithTitle:@"To" andTag:2];
        }
    } else if (indexPath.section == 2)
    {
        [_delegate deleteEvent:_event withController:self];
    }
}


- (IBAction)saveAction:(id)sender
{
    if (self.eventTitle.text.length == 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Your event must have a title !"];
        return;
    }
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* fromDateStr = [NSString stringWithFormat:@"%@ %@:00",[outputFormatter stringFromDate:self.date], _fromStr];
    NSString* toDateStr = [NSString stringWithFormat:@"%@ %@:00",[outputFormatter stringFromDate:self.date], _toStr];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* fromDate = [outputFormatter dateFromString:fromDateStr];
    NSDate* toDate = [outputFormatter dateFromString:toDateStr];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];

    
    _event.title = self.eventTitle.text;
    _event.start = fromDate;
    _event.end = toDate;
    [_delegate performEdition:self onEvent:_event];
}

- (IBAction)removeAction:(id)sender
{
    [_delegate deleteEvent:_event withController:self];
}

@end
