//
//  PIBugDataController.h
//  PlanIt
//
//  Created by Irenicus on 16/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIBug, PITask, PIUser;
@interface PIBugDataController : NSObject

@property (nonatomic, retain) NSMutableArray* taskList;

- (void)initializeBugListOnComplete:(void(^)(void))complete;

- (NSInteger)countOfTaskList;

- (NSInteger) countOfBugAtSection:(NSInteger) section;

- (PITask*) taskInListAtSection:(NSInteger)section;



- (void)createBugWithName:(NSString*) name
                     Type:(NSString*) type
           AssociatedTask:(PITask*) task
              Responsable:(PIUser*)responsable
                  release:(NSString*) release
           estimationTime:(NSString*) estimation
              Description:(NSString*) description
                 Priority:(NSString*) priority
                 CallBack:(void(^)(PIBug* bug))callback;

- (void) addBugToList: (PIBug*) bug;


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
             CallBack:(void(^)(void))callback;

- (void) deleteBugAtRow: (NSInteger) row  AndSection: (NSInteger) section;

- (void) deleteBugAtRow: (NSInteger) row  AndSection: (NSInteger) section onSuccess:(void(^)(void))callback;


@end
