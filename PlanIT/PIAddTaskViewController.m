//
//  AddTaskController.m
//  PlanIt
//
//  Created by Irenicus on 28/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIAddTaskViewController.h"

#import "PIClientAPI.h"

#import "PITask.h"

@implementation PIAddTaskViewController
@synthesize delegate = _delegate;
@synthesize task = _task;

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _task = [[PITask alloc] init];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    self.textView.delegate = self;
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
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 125, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) resetFrame
{
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self frameUp];
}


- (IBAction)doneAction:(id)sender {
    
    
    if (self.taskField.text.length == 0) {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You must give a name to your task !"];
    }
    else {
        NSString* priority;
        switch (self.prioritySegmented.selectedSegmentIndex) {
            case 0:
                priority = @"Low";
                break;
            case 1:
                priority = @"Medium";
                break;
            default:
                priority = @"High";
        }
        _task.name = self.taskField.text;
        _task.description = self.textView.text;
        _task.priority = priority;
        [_delegate addTask:_task DidSucces:self];
    }
    
}

- (IBAction)cancelAction:(id)sender {
    [_delegate addTaskDidCancel:self];
}


@end
