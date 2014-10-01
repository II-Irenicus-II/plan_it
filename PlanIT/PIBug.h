//
//  Bug.h
//  PlanIt
//
//  Created by Irenicus on 09/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PITask;
@class PIUser;
@interface PIBug : NSObject

@property NSInteger ID;
@property (nonatomic, retain) PITask* task;
@property (nonatomic, retain) PIUser* responsable;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* priority;
@property NSInteger progress;
@property (nonatomic, retain) NSString* released;
@property NSTimeInterval estimation;
@property NSTimeInterval spent_time;

@property NSInteger user_id;
@property NSInteger task_id;


@end
