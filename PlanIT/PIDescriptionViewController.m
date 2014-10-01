//
//  FeatureDescriptionController.m
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIDescriptionViewController.h"

@implementation PIDescriptionViewController
@synthesize delegate = _delegate;

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.textView.text = [_delegate getDescription];
}

- (void) resetFrame
{
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height + 162);
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height - 162);
}

- (void) didMoveToParentViewController:(UIViewController *)parent
{
    [_delegate setDescription:self.textView.text];
}

@end
