//
//  PIClientAPI.h
//  PlanIt
//
//  Created by Irenicus on 16/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class PIProject,PIUser, PIProfile, PIResource,PITask, PIBug, PIFeature, PIEvent;
@interface PIClientAPI : NSObject

+ (id)sharedInstance;

#pragma mark - Projects


- (void) getProjectsOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* projects))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void) setProjectID: (NSInteger) projectID
              success:(void (^)(AFHTTPRequestOperation *operation, PIProject* project))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - Users

- (void) loginWithParameters: (NSDictionary*) parameters
                     success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) getUsersOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* users))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void) createUser: (NSDictionary*) user
            success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void) getUserFromID: (NSInteger) userID
               success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void) editUser: (NSInteger) userID
       parameters: (NSDictionary*) user
          success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void) deleteUser: (NSInteger) userID
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Profiles

- (void) getProfilesOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* profiles))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void) getProfileFromID:(NSInteger) profileID
                  success:(void (^)(AFHTTPRequestOperation *operation, PIProfile* profile))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Resources

- (void) getDocumentsOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* pictures))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) getPicturesOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* pictures))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void) readDocumentAtIndexPath:(NSString*) path
                       Onsuccess:(void (^)(AFHTTPRequestOperation *operation, NSString* fullPath))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Wiki

- (void) getSectionsOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* sections))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) getArticlesOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* articles))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



- (void) getRoadmapOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* tasks, NSInteger progress))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - Tasks

- (void) getTasksOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* tasks))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) getTaskWithId:(NSInteger) taskID
             OnSuccess:(void (^)(AFHTTPRequestOperation *operation, PITask* task))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) createTask:(NSDictionary *)task success:(void (^)(AFHTTPRequestOperation * operation, PITask* task))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



- (void) editTask: (NSInteger) taskID
       parameters: (NSDictionary*) TaskDic
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) deleteTask: (NSInteger) taskID
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Features

- (void) getFeaturesOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* features))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) createFeature:(NSDictionary *)feature success:(void (^)(AFHTTPRequestOperation* operation, PIFeature* feature))success
               failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void) editFeature: (NSInteger) featureID
          parameters: (NSDictionary*) featureDic
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) deleteFeature: (NSInteger) featureID
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Bugs

- (void) getBugsOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* features))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) createBug:(NSDictionary *)bug success:(void (^)(AFHTTPRequestOperation* operation, PIBug* bug))success
           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (void) editBug: (NSInteger) bugID
      parameters: (NSDictionary*) bugDic
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (void) deleteBug: (NSInteger) bugID
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Events


- (void) getEventsOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* events))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) createEvent:(NSDictionary *)event success:(void (^)(AFHTTPRequestOperation* operation, PIEvent* event))success
           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


- (void) editEvent: (NSInteger) eventID
      parameters: (NSDictionary*) eventDic
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) deleteEvent: (NSInteger) eventID
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
