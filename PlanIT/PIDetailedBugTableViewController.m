//
//  DetailedBugViewController.m
//  PlanIt
//
//  Created by Irenicus on 09/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIDetailedBugTableViewController.h"

#import "PIClientAPI.h"

#import "PITasksListTableViewController.h"
#import "PIBugTypeTableViewController.h"
#import "PIResponsableTableViewController.h"
#import "PIDescriptionViewController.h"
#import "PIBugStatusTableViewController.h"

#import "Tools.h"

#import "PIBug.h"
#import "PITask.h"
#import "PIUser.h"


@interface PIDetailedBugTableViewController () <PITasksListTableViewControllerDelegate, PIBugTypeTableViewControllerDelegate, PIResponsableTableViewControllerDelegate, PIDescriptionViewControllerDelegate, PIBugStatusTableViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation PIDetailedBugTableViewController

@synthesize bug = _bug;
@synthesize delegate = _delegate;
@synthesize description = _description;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self initBug];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) initBug
{
    [[PIClientAPI sharedInstance] getUserFromID:_bug.user_id success:^(AFHTTPRequestOperation *operation, PIUser *user) {
        _bug.responsable = user;
        [self setActiveUser:_bug.responsable];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    _description = @"";
    self.taskField.text = _bug.task.name;
    self.typeField.text = _bug.type;
    self.nameField.text = _bug.name;
    self.releaseField.text = _bug.released;
    self.statusField.text = _bug.status;
    
    if ([_bug.priority isEqualToString:@"Low"]) {
        self.prioritySegment.selectedSegmentIndex = 0;
    }
    else if ([_bug.priority isEqualToString:@"Medium"]){
        self.prioritySegment.selectedSegmentIndex = 1;
    }
    else {
        self.prioritySegment.selectedSegmentIndex = 2;
    }
    self.estimationTime = _bug.estimation;
    self.spentTime = _bug.spent_time;
    
    [self updateTimers];
    [self setActiveTask:_bug.task];
    [self updateProgress:_bug.progress];
}

- (void) updateTimers
{
    self.estimatedField.text = [Tools stringHourAndMinutesFromTimeInterval:_bug.estimation];
    self.spentField.text = [Tools stringHourAndMinutesFromTimeInterval:_bug.spent_time];
}

- (void) updateProgress:(NSInteger)progress
{
    _bug.progress = progress;
    float progressF = progress;
    progressF /= 100;
    [self.progressView setProgress:progressF];
}


- (IBAction)saveAction:(id)sender {
    if (self.nameField.text.length == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must give a name to the bug."];
    }else
    {
        _bug.name = self.nameField.text;
        _bug.type = self.typeField.text;
        _bug.released = self.releaseField.text;
        _bug.status = self.statusField.text;
        _bug.estimation = self.estimationTime;
        _bug.spent_time = self.spentTime;
        _bug.description = _description;
        _bug.priority = [self.prioritySegment titleForSegmentAtIndex:self.prioritySegment.selectedSegmentIndex];
        [_delegate performEdition:self onBug:_bug withEstimation:self.estimatedField.text andSpentTime:self.spentField.text];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Action Sheets

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
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [actionSheet addSubview:datePicker];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet setBounds:CGRectMake(0,0, 320, 411)];
}

- (void) actionSheetProgressBarWithTitle: (NSString*) title
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Done"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet setTag:1];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(60, 90 , 200, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.text = [NSString stringWithFormat:@"%ld%%", (long)_bug.progress];
    UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 100, 280, 100)];
    slider.minimumValue = 0.0;
    slider.maximumValue = 100.0;
    slider.continuous = YES;
    slider.value = _bug.progress;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:label];
    [actionSheet addSubview:slider];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet setBounds:CGRectMake(0,0, 320, 300)];
}


-(IBAction)sliderValueChanged:(UISlider *)sender
{
    UIActionSheet* actionSheet = (UIActionSheet*) sender.superview;
    UILabel* label = [actionSheet.subviews objectAtIndex:3];
    label.text = [NSString stringWithFormat:@"%d%%", (int)sender.value];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 1:
        {
            UISlider* slider = [actionSheet.subviews objectAtIndex:4];
            [self updateProgress:(int)slider.value];
        }
            break;
        case 2:
        {
            UIDatePicker* datePicker = [actionSheet.subviews objectAtIndex:3];
            self.estimationTime = datePicker.countDownDuration;
            self.estimatedField.text = [Tools stringHourAndMinutesFromTimeInterval:self.estimationTime];
        }
            break;
        case 3:
        {
            UIDatePicker* datePicker = [actionSheet.subviews objectAtIndex:3];
            self.spentTime = datePicker.countDownDuration;
            self.spentField.text = [Tools stringHourAndMinutesFromTimeInterval:self.spentTime];
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"detailedBugTaskSegue" sender:self];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"detailedBugTypeSegue" sender:self];
        }
    } else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [self performSegueWithIdentifier:@"detailedBugStatusSegue" sender:self];
        } else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"detailedBugResponsableSegue" sender:self];
        }
        else if (indexPath.row == 2)
        {
            [self actionSheetProgressBarWithTitle:@"Progress :"];
        }
    } else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            [self actionSheetDatePickerWithTitle:@"Estimated Time" andTag:2];
        }
        if (indexPath.row == 1)
        {
            [self actionSheetDatePickerWithTitle:@"Spent Time" andTag:3];
        }
    } else if (indexPath.section == 4)
    {
        [self performSegueWithIdentifier:@"detailedBugDescriptionSegue" sender:self];
    }
}


#import "PIDescriptionViewController.h"


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailedBugTaskSegue"])
    {
        PITasksListTableViewController * tlt = [segue destinationViewController];
        tlt.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"detailedBugTypeSegue"])
    {
        PIBugTypeTableViewController * btt = [segue destinationViewController];
        btt.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"detailedBugStatusSegue"])
    {
        PIBugStatusTableViewController* bst = [segue destinationViewController];
        bst.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"detailedBugResponsableSegue"])
    {
        PIResponsableTableViewController* rst = [segue destinationViewController];
        rst.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"detailedBugDescriptionSegue"])
    {
        PIDescriptionViewController* dvx = [segue destinationViewController];
        dvx.delegate = self;
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
    _description = description;;
}

- (NSString*) getDescription
{
    return _bug.description;
}

#pragma mark Task Delegate


- (void) setActiveTask:(PITask*) task;
{
    _bug.task = task;
    _bug.task_id = task.ID;
    self.taskField.text = task.name;
}

#pragma mark Bug Type delegate

- (void) setActiveType:(NSString*) type;
{
    self.typeField.text = type;
}

#pragma mark Bug Status delegate


- (void) setActiveStatus:(NSString*) status
{
    self.statusField.text = status;
}


@end


