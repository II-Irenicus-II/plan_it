//
//  PIFeatureDataController.m
//  PlanIt
//
//  Created by Irenicus on 16/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIClientAPI.h"

#import "PIFeatureDataController.h"

#import "PITask.h"
#import "PIUser.h"
#import "PIFeature.h"

@implementation PIFeatureDataController



- (void)initializeFeatureListOnComplete:(void(^)(void))complete
{
    _taskList = [[NSMutableArray alloc] init];
    [[PIClientAPI sharedInstance] getTasksOnSuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *tasks) {
        _taskList = tasks;
        complete();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)initializeFeaturesWithTaskID:(NSInteger) taskID OnComplete:(void(^)(void))complete
{
    _taskList = [[NSMutableArray alloc] init];
    [[PIClientAPI sharedInstance] getTaskWithId:taskID OnSuccess:^(AFHTTPRequestOperation *operation, PITask *task) {
        [_taskList addObject:task];
        complete();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


- (NSInteger)countOfTaskList
{
    return [_taskList count];
}


- (NSInteger) countOfFeatureAtSection:(NSInteger) section
{
    return [[[_taskList objectAtIndex:section] features] count];
    
}

- (PITask*) taskInListAtSection:(NSInteger)section
{
    return [_taskList objectAtIndex:section];
}

- (void)createFeatureWithName:(NSString*) name
                     Type:(NSString*) type
           AssociatedTask:(PITask*) task
              Responsable:(PIUser*)responsable
                  release:(NSString*) release
           estimationTime:(NSString*) estimation
              Description:(NSString*) description
                 Priority:(NSString*) priority
                 CallBack:(void(^)(PIFeature* feature))callback
{
    NSDictionary* featureDic = @{
                             @"feature" :
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
    [[PIClientAPI sharedInstance] createFeature:featureDic success:^(AFHTTPRequestOperation *operation, PIFeature *feature) {
        callback(feature);
    } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
        
    }];
    
}

- (void) addFeatureToList: (PIFeature*) feature
{
    NSInteger index = 0;
    for (PITask* t in _taskList) {
        if (t.ID == feature.task_id) {
            [[[_taskList objectAtIndex:index] features] addObject:feature];
            break;
        }
        index++;
    }
}


- (void)editFeatureWithID:(NSInteger) ID
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
    NSDictionary* featureDic = @{
                             @"feature" :
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
    [[PIClientAPI sharedInstance] editFeature:ID parameters:featureDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
};

- (void) deleteFeatureAtRow: (NSInteger) row  AndSection: (NSInteger) section
{
    [[[_taskList objectAtIndex:section] features] removeObjectAtIndex:row];
}


- (void) deleteFeatureAtRow: (NSInteger) row  AndSection: (NSInteger) section onSuccess:(void(^)(void))callback
{
    NSInteger featureID = [[[[_taskList objectAtIndex:section] features] objectAtIndex:row ] ID];
    [[PIClientAPI sharedInstance] deleteFeature:featureID success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self deleteFeatureAtRow:row AndSection:section];
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
