//
//  AddBugTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 17/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIAddBugTableViewController.h"

#import "PITasksListTableViewController.h"
#import "PIBugTypeTableViewController.h"
#import "PIResponsableTableViewController.h"
#import "PIDescriptionViewController.h"

#import "PIBug.h"
#import "PIUser.h"
#import "PITask.h"

#import "Tools.h"


@interface PIAddBugTableViewController () <PITasksListTableViewControllerDelegate, PIBugTypeTableViewControllerDelegate, PIResponsableTableViewControllerDelegate, PIDescriptionViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation PIAddBugTableViewController
@synthesize bug = _bug;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self initBug];
}

- (void) initBug
{
    _bug = [[PIBug alloc] init];
    _bug.priority = @"Low";
    _bug.description = @"";
    self.countdown = 0;
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


#pragma mark - Action Sheets

- (void) actionSheetDatePickerWithTitle: (NSString*) title
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Done"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,100, 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [actionSheet addSubview:datePicker];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0,0, 320, 411)];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIDatePicker* datePicker = [actionSheet.subviews objectAtIndex:3];
    self.countdown = datePicker.countDownDuration;
    self.estimatedField.text = [Tools stringHourAndMinutesFromTimeInterval:self.countdown];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"addBugTaskSegue" sender:self];
        } else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"addBugTypeSegue" sender:self];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"addBugResponsableSegue" sender:self];
    }
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        [self actionSheetDatePickerWithTitle:@"Estimated time:"];
    }
    if (indexPath.section == 4 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"addBugDescriptionSegue" sender:self];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addBugTaskSegue"]) {
        PITasksListTableViewController* tsc = [segue destinationViewController];
        tsc.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"addBugTypeSegue"])
    {
        PIBugTypeTableViewController* btv = [segue destinationViewController];
        btv.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"addBugResponsableSegue"])
    {
        PIResponsableTableViewController* rct = [segue destinationViewController];
        rct.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"addBugDescriptionSegue"])
    {
        PIDescriptionViewController* rct = [segue destinationViewController];
        rct.delegate = self;
    }
}

- (IBAction)cancelAction:(id)sender {
    [_delegate addBugDidCancel:self];
}

- (IBAction)doneAction:(id)sender {
    if (self.nameField.text.length == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must give a name to the bug."];
    } else if (self.typeField.text.length == 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must give a type to the bug."];
    } else if (_bug.responsable == nil)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must select a responsable for the bug."];
    } else if (_bug.task == nil)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must select a task for the bug."];
    } else if (self.estimatedField.text.length == 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"ou must give an estimation to the bug."];
    } else
    {
        _bug.name = self.nameField.text;
        _bug.type = self.typeField.text;
        _bug.released = self.releaseField.text;
        _bug.estimation = self.countdown;
        _bug.priority = [self.prioritySegment titleForSegmentAtIndex:self.prioritySegment.selectedSegmentIndex];
        [_delegate addBug:_bug withEstimation: self.estimatedField.text DidSuccess:self];
    }
}

#pragma mark Responsable Delegate

- (void) setActiveUser:(PIUser*) responsable
{
    _bug.responsable = responsable;
    self.responsableField.text = [NSString stringWithFormat:@"%@ %@",responsable.firstName, responsable.lastName];
}

#pragma mark Description Delegate


- (void) setDescription:(NSString*) description
{
    _bug.description = description;
}

- (NSString*) getDescription
{
    return _bug.description;
}

#pragma mark Task Delegate


- (void) setActiveTask:(PITask*) task;
{
    _bug.task = task;
    self.taskField.text = task.name;
}

#pragma mark Bug Type delegate

- (void) setActiveType:(NSString*) type;
{
    self.typeField.text = type;
}

@end
