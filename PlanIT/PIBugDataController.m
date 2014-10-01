//
//  PIBugDataController.m
//  PlanIt
//
//  Created by Irenicus on 16/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIBugDataController.h"

#import "PIClientAPI.h"

#import "PITask.h"
#import "PIUser.h"
#import "PIBug.h"

@implementation PIBugDataController


- (void)initializeBugListOnComplete:(void(^)(void))complete
{
    _taskList = [[NSMutableArray alloc] init];
    [[PIClientAPI sharedInstance] getTasksOnSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *tasks) {
        
        
        
        _taskList = tasks;
        complete();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (NSInteger)countOfTaskList
{
    return [_taskList count];
}


- (NSInteger) countOfBugAtSection:(NSInteger) section
{
    return [[[_taskList objectAtIndex:section] bugs] count];

}

- (PITask*) taskInListAtSection:(NSInteger)section
{
    return [_taskList objectAtIndex:section];
}

- (void)createBugWithName:(NSString*) name
                     Type:(NSString*) type
           AssociatedTask:(PITask*) task
              Responsable:(PIUser*)responsable
                  release:(NSString*) release
               estimationTime:(NSString*) estimation
              Description:(NSString*) description
                 Priority:(NSString*) priority
                 CallBack:(void(^)(PIBug* bug))callback
{
    NSDictionary* bugDic = @{
                             @"bug" :
                                 @{
                                     @"name" : name,
                                     @"type_of_content" : type,
                                     @"task_id" : [NSString stringWithFormat:@"%ld", (long)task.ID],
                                     @"user_id" : [NSString stringWithFormat:@"%ld", (long)responsable.ID],
                                     @"release" : release,
                                     @"estimation" : estimation,
                                     @"priority" : priority,
                                     @"description" : description
                                 }
                             };
    [[PIClientAPI sharedInstance] createBug:bugDic success:^(AFHTTPRequestOperation *operation, PIBug *bug) {
        callback(bug);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
    }];

}

- (void) addBugToList: (PIBug*) bug
{
    NSInteger index = 0;
    for (PITask* t in _taskList) {
        if (t.ID == bug.task_id) {
            [[[_taskList objectAtIndex:index] bugs] addObject:bug];
            break;
        }
        index++;
    }
}




- (void)editBugWithID:(NSInteger) ID
                 Name:(NSString*) name
                 Type:(NSString*) type
       AssociatedTask:(PITask*) task
          Responsable:(PIUser*)responsable
               status:(NSString*) status
              release:(NSString*) release
       estimationTime:(NSString*) estimation
            spentTime:(NSString*) spent
          progression:(NSInteger) progress
          Description:(NSString*) description
             Priority:(NSString*) priority
             CallBack:(void(^)(void))callback
{
    NSDictionary* bugDic = @{
                             @"bug" :
                                 @{
                                     @"name" : name,
                                     @"type_of_content" : type,
                                     @"task_id" : [NSString stringWithFormat:@"%ld", (long)task.ID],
                                     @"user_id" : [NSString stringWithFormat:@"%ld", (long)responsable.ID],
                                     @"status" : status,
                                     @"release" : release,
                                     @"estimation" : estimation,
                                     @"spent" : spent,
                                     @"progress" :[NSString stringWithFormat:@"%ld", (long)progress],
                                     @"priority" : priority,
                                     @"description" : description
                                     }
                             };
    [[PIClientAPI sharedInstance] editBug:ID parameters:bugDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
};

- (void) deleteBugAtRow: (NSInteger) row  AndSection: (NSInteger) section
{
    [[[_taskList objectAtIndex:section] bugs] removeObjectAtIndex:row];
}




- (void) deleteBugAtRow: (NSInteger) row  AndSection: (NSInteger) section onSuccess:(void(^)(void))callback
{
    NSInteger bugID = [[[[_taskList objectAtIndex:section] bugs] objectAtIndex:row ] ID];
    [[PIClientAPI sharedInstance] deleteBug:bugID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self deleteBugAtRow:row AndSection:section];
         callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
