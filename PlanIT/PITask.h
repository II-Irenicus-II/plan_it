//
//  Task.h
//  PlanIt
//
//  Created by Irenicus on 27/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIProject;
@interface PITask : NSObject

@property NSInteger ID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* status;
@property NSInteger progress;
@property (nonatomic, retain) NSString* priority;
@property (nonatomic, retain) NSMutableArray* bugs;
@property (nonatomic, retain) NSMutableArray* features;


- (NSComparisonResult) hasMoreBugsThanTask:(PITask*) task;

- (NSComparisonResult) hasMorFeaturesThanTask:(PITask*) task;

@end
