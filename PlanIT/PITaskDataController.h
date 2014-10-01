//
//  PITaskDataController.h
//  PlanIt
//
//  Created by Irenicus on 16/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PITask;


@interface PITaskDataController : NSObject

@property (nonatomic, retain) NSMutableArray* taskList;

- (void)initializeTaskListOnComplete:(void(^)(void))complete;

- (void) initializeRoadmapTaskListOnComplete:(void (^)(NSInteger progress))complete;


- (NSInteger)countOfList;

- (PITask*)taskInListAtIndex:(NSInteger)index;

- (void)createTaskWithName:(NSString*) name
               Description:(NSString*) description
                  Priority:(NSString*) priority
                  CallBack:(void(^)(PITask* task))callback;

- (void) addTaskToList: (PITask*) task;

- (void) replaceTaskAtIndex: (NSInteger) row byTask: (PITask*) task;


- (void)editTaskWithID:(NSInteger) ID
                  Name:(NSString*) name
           Description:(NSString*) description
              Priority:(NSString*) priority
              callBack:(void(^)(void))callback;


- (void) deleteTaskAtRow: (NSInteger) row onSuccess:(void(^)(void))callback;


@end
