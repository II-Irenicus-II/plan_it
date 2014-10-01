//
//  Task.m
//  PlanIt
//
//  Created by Irenicus on 27/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PITask.h"

@implementation PITask
@synthesize ID = _ID, name = _name, description = _description, status = _status;
@synthesize progress = _progress, priority = _priority;

@synthesize bugs = _bugs;
@synthesize features = _features;

- (NSComparisonResult) hasMoreBugsThanTask:(PITask*) task;
{
    return [self.bugs count] >= [task.bugs count];
}

- (NSComparisonResult) hasMorFeaturesThanTask:(PITask*) task;
{
    return [self.features count] >= [task.features count];
}


@end
