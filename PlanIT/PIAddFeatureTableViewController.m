//
//  AddFeatureTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 18/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIAddFeatureTableViewController.h"

#import "PITasksListTableViewController.h"
#import "PIResponsableTableViewController.h"
#import "PIDescriptionViewController.h"

#import "PIFeature.h"
#import "PIUser.h"
#import "PITask.h"

#import "Tools.h"


@interface PIAddFeatureTableViewController () <PITasksListTableViewControllerDelegate, PIResponsableTableViewControllerDelegate, PIDescriptionViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation PIAddFeatureTableViewController
@synthesize feature = _feature;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self initFeature];
}

- (void) initFeature
{
    _feature = [[PIFeature alloc] init];
    _feature.priority = @"Low";
    _feature.description = @"";
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
            [self performSegueWithIdentifier:@"addFeatureTaskSegue" sender:self];
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"addFeatureResponsableSegue" sender:self];
    }
    if (indexPath.section == 2 && indexPath.row == 0)
    {
        [self actionSheetDatePickerWithTitle:@"Estimated time:"];
    }
    if (indexPath.section == 4 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"addFeatureDescriptionSegue" sender:self];
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addFeatureTaskSegue"]) {
        PITasksListTableViewController* tsc = [segue destinationViewController];
        tsc.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"addFeatureResponsableSegue"])
    {
        PIResponsableTableViewController* rct = [segue destinationViewController];
        rct.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"addFeatureDescriptionSegue"])
    {
        PIDescriptionViewController* rct = [segue destinationViewController];
        rct.delegate = self;
    }
}

- (IBAction)cancelAction:(id)sender {
    [_delegate addFeatureDidCancel:self];
}

- (IBAction)doneAction:(id)sender {
    if (self.nameField.text.length == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must give a name to the feature."];
    } else if (_feature.responsable == nil)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must select a responsable for the feature."];
    } else if (_feature.task == nil)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must select a task for the feature."];
    } else if (self.estimatedField.text.length == 0)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must give an estimation to the feature."];
    } else
    {
        _feature.name = self.nameField.text;
        _feature.type = self.typeField.text;
        _feature.released = self.releaseField.text;
        _feature.estimation = self.countdown;
        _feature.priority = [self.prioritySegment titleForSegmentAtIndex:self.prioritySegment.selectedSegmentIndex];
        [_delegate addFeature:_feature withEstimation:self.estimatedField.text DidSuccess:self];
    }
}

#pragma mark Responsable Delegate

- (void) setActiveUser:(PIUser*) responsable
{
    _feature.responsable = responsable;
    self.responsableField.text = [NSString stringWithFormat:@"%@ %@",responsable.firstName, responsable.lastName];
}

#pragma mark Description Delegate


- (void) setDescription:(NSString*) description
{
    _feature.description = description;
}

- (NSString*) getDescription
{
    return _feature.description;
}

#pragma mark Task Delegate


- (void) setActiveTask:(PITask*) task;
{
    _feature.task = task;
    self.taskField.text = task.name;
}

#pragma mark Bug Type delegate

- (void) setActiveType:(NSString*) type;
{
    self.typeField.text = type;
}

@end