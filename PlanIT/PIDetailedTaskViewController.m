//
//  DetailedViewController.m
//  PlanIt
//
//  Created by Irenicus on 28/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIDetailedTaskViewController.h"
#import "PIFeaturesTableViewController.h"

#import "PIFeatureDataController.h"

#import "PITask.h"

@implementation PIDetailedTaskViewController

@synthesize task = _task;

@synthesize delegate = _delegate;


- (void) viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [self initTask];
   }

- (void) initTask
{
     self.nameTextField.text = _task.name;
    float progress = _task.progress;
    progress /= 100;
    [self.progressView setProgress:progress];
    self.descriptionView.text = _task.description;
    if ([_task.priority isEqualToString:@"Low"]) {
        self.prioritySegmented.selectedSegmentIndex = 0;
    }
    else if ([_task.priority isEqualToString:@"Medium"]){
        self.prioritySegmented.selectedSegmentIndex = 1;
    }
    else {
        self.prioritySegmented.selectedSegmentIndex = 2;
    }

}

- (IBAction)saveAction:(id)sender {
    if ([self.nameTextField.text length] == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must give a name to your task !"];
    } else {
        NSString* priority = [self.prioritySegmented titleForSegmentAtIndex:self.prioritySegmented.selectedSegmentIndex];
        _task.name = self.nameTextField.text;
        _task.description = self.descriptionView.text;
        _task.priority = priority;
        [_delegate performEdition:self onTask:_task];
    }
}

- (IBAction)featuresAction:(id)sender {
    [self performSegueWithIdentifier:@"detailedTaskFeaturesSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailedTaskFeaturesSegue"]) {
        PIFeaturesTableViewController* ftc = [segue destinationViewController];
        ftc.dataController = [[PIFeatureDataController alloc] init];
        [ftc.dataController initializeFeaturesWithTaskID:_task.ID OnComplete:^{
            [ftc.tableView reloadData];
        }];
    }
}
- (void) hideKeyboard {
    [self.view endEditing:YES];
    [self resetFrame];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) frameUp
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 160, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) resetFrame
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self frameUp];
}

@end


