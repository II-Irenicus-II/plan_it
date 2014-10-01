//
//  AddEventViewController.m
//  PlanIt
//
//  Created by Irenicus on 25/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIAddEventViewController.h"

#import "PIEvent.h"

@interface PIAddEventViewController () <UIActionSheetDelegate>

@end

@implementation PIAddEventViewController
@synthesize delegate = _delegate;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.fromStr = @"10:00";
    self.toStr = @"12:00";
    self.eventFromField.text = self.fromStr;
    self.eventToField.text = self.toStr;
    
    if (self.preferedDate != nil) {
        [self.datePicker setDate:self.preferedDate];
    }
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
}

#pragma mark UIActionSheetDelegate

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
    NSLocale *twentyFour = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [datePicker setLocale:twentyFour];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:self.view];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self actionSheetDatePickerWithTitle:@"From" andTag:1];
        } else if (indexPath.row == 1)
        {
            [self actionSheetDatePickerWithTitle:@"To" andTag:2];
        }
            
    }
}

- (IBAction)doneAction:(id)sender {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* fromDateStr = [NSString stringWithFormat:@"%@ %@:00",[outputFormatter stringFromDate:self.datePicker.date], _fromStr];
    NSString* toDateStr = [NSString stringWithFormat:@"%@ %@:00",[outputFormatter stringFromDate:self.datePicker.date], _toStr];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* fromDate = [outputFormatter dateFromString:fromDateStr];
    NSDate* toDate = [outputFormatter dateFromString:toDateStr];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
    
    if (_eventTitle.text.length == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Your event must have a title !"];
        return;
    }
    
    PIEvent* e = [[PIEvent alloc] init];
    e.title = _eventTitle.text;
    e.start = fromDate;
    e.end = toDate;
    
    [_delegate addEvent:e DidSuccess:self];
}

- (IBAction)cancelAction:(id)sender {
    [_delegate addEventDidCancel:self];
}

- (void) setDatePickerToDate:(NSDate*) date
{
    self.datePicker.date = date;
}


@end
