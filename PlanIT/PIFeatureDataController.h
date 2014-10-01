//
//  PIFeatureDataController.h
//  PlanIt
//
//  Created by Irenicus on 16/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIFeature, PITask, PIUser;
@interface PIFeatureDataController : NSObject

@property (nonatomic, retain) NSMutableArray* taskList;

- (void)initializeFeatureListOnComplete:(void(^)(void))complete;

- (void)initializeFeaturesWithTaskID:(NSInteger) taskID OnComplete:(void(^)(void))complete;


- (NSInteger)countOfTaskList;

- (NSInteger) countOfFeatureAtSection:(NSInteger) section;

- (PITask*) taskInListAtSection:(NSInteger)section;



- (void)createFeatureWithName:(NSString*) name
                     Type:(NSString*) type
           AssociatedTask:(PITask*) task
              Responsable:(PIUser*)responsable
                  release:(NSString*) release
           estimationTime:(NSString*) estimation
              Description:(NSString*) description
                 Priority:(NSString*) priority
                 CallBack:(void(^)(PIFeature* bug))callback;

- (void) addFeatureToList: (PIFeature*) feature;


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
             CallBack:(void(^)(void))callback;

- (void) deleteFeatureAtRow: (NSInteger) row  AndSection: (NSInteger) section;


- (void) deleteFeatureAtRow: (NSInteger) row  AndSection: (NSInteger) section onSuccess:(void(^)(void))callback;

@end