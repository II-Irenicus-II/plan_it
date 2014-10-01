//
//  PITaskDataController.m
//  PlanIt
//
//  Created by Irenicus on 16/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PITaskDataController.h"

#import "PIClientAPI.h"

#import "PITask.h"

@interface PITaskDataController ()

@end

@implementation PITaskDataController
@synthesize taskList = _taskList;

- (id)init
{
    self = [super init];
    if (self) {
        _taskList = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)initializeTaskListOnComplete:(void(^)(void))complete
{
    [[PIClientAPI sharedInstance] getTasksOnSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *tasks) {
        _taskList = tasks;
        complete();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void) initializeRoadmapTaskListOnComplete:(void (^)(NSInteger progress))complete
{
    [[PIClientAPI sharedInstance] getRoadmapOnSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *tasks, NSInteger progress) {
        _taskList = tasks;
        complete(progress);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)countOfList
{
    return [_taskList count];
}

- (PITask*)taskInListAtIndex:(NSInteger)index
{
    return [_taskList objectAtIndex:index];
}


- (void)createTaskWithName:(NSString*) name
               Description:(NSString*) description
                  Priority:(NSString*) priority
                  CallBack:(void (^)(PITask * task))callback
{
    NSDictionary* taskDic = @{ @"task" :
                                   @{
                                       @"name" : name,
                                       @"description" : description,
                                       @"priority" : priority
                                       }
                               };
    [[PIClientAPI sharedInstance] createTask:taskDic success:^(AFHTTPRequestOperation *operation, PITask *task) {
        callback(task);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void) addTaskToList: (PITask*) task
{
    [_taskList addObject:task];
}

- (void) replaceTaskAtIndex: (NSInteger) row byTask: (PITask*) task

{
    [_taskList replaceObjectAtIndex:row withObject:task];
}


- (void)editTaskWithID:(NSInteger) ID
                  Name:(NSString*) name
           Description:(NSString*) description
              Priority:(NSString*) priority
              callBack:(void(^)(void))callback
{
    NSDictionary* taskDic = @{ @"task" :
                                   @{
                                       @"name" : name,
                                       @"description" : description,
                                       @"priority" : priority
                                       }
                               };
   [[PIClientAPI sharedInstance] editTask:ID parameters:taskDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       callback();
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
   }];
}


- (void) deleteTaskAtRow: (NSInteger) row onSuccess:(void(^)(void))callback
{
    NSInteger taskID = [[self taskInListAtIndex:row] ID];
    
    [[PIClientAPI sharedInstance] deleteTask:taskID success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [_taskList removeObjectAtIndex:row];
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
