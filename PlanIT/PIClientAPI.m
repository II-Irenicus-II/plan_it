//
//  PIClientAPI.m
//  PlanIt
//
//  Created by Irenicus on 16/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary.h>

#import "PIClientAPI.h"

#import "Tools.h"
#import "NSDateFormatter+RFC822.h"

#import "PIProject.h"
#import "PIUser.h"
#import "PIProfile.h"
#import "PISection.h"
#import "PIArticle.h"
#import "PIResource.h"
#import "PITask.h"
#import "PIFeature.h"
#import "PIBug.h"
#import "PIFeature.h"
#import "PIEvent.h"

static NSString * const PIBaseUrlString =@"http://192.168.1.33:3000/";

@interface PIClientAPI ()

#pragma mark basic requests


- (void) getResource: (NSString*) name parameters: (NSDictionary*) parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) postResource: (NSString*) name parameters: (NSDictionary*) parameters
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) editResource: (NSString*) name withID: (NSInteger) ID parameters: (NSDictionary*) parameters
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void) deleteResource: (NSString*) name parameters: (NSDictionary *)parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark helpers

- (PIUser*) userFromDic:(NSDictionary*) userDic;
- (PIProfile*) profileFromDic:(NSDictionary*) profileDic;
- (PIProject*) projectFromDic:(NSDictionary*) projectDic;
- (void) getResources:(NSString*) resourceName
            Onsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* documents))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (PIResource*) resourceFromDic:(NSDictionary*) resourceDic;
- (PISection*) sectionFromDic:(NSDictionary*) sectionDic;
- (PIArticle*) articleFromDic:(NSDictionary*) articleDic;
- (PITask*) taskFromDic:(NSDictionary*) taskDic;


@end

@implementation PIClientAPI

+ (id)sharedInstance {
    static dispatch_once_t once;
    static PIClientAPI *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[PIClientAPI alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Resources;


- (void) getResource: (NSString*) name parameters: (NSDictionary*) parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@",PIBaseUrlString, name] parameters:parameters
         success:success
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Error : resource \"%@\" is not available!", name]];
             NSLog(@"Connection : Failure \n%@",error);
             failure(operation, error);
         }];
}

- (void) postResource: (NSString*) name parameters: (NSDictionary*) parameters
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",PIBaseUrlString, name] parameters:parameters
          success:success
          failure:failure];
}

- (void) editResource: (NSString*) name withID: (NSInteger) ID parameters: (NSDictionary*) parameters
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[NSString stringWithFormat:@"%@%@/%ld",PIBaseUrlString, name, (long)ID] parameters:parameters
         success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"Edition failed :  \"%@\"!", name]];
             NSLog(@"Connection : Failure \n%@",error);
         }];
}

- (void) deleteResource: (NSString*) name parameters: (NSDictionary *)parameters
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:[NSString stringWithFormat:@"%@%@", PIBaseUrlString ,name] parameters:parameters success:success failure:failure];
}


#pragma mark - Projects

- (void) getProjectsOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* projects))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    [self getResource:@"projects" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray* projects = [[NSMutableArray alloc] init];
        for (NSDictionary* project in responseObject) {
            [projects addObject:[self projectFromDic:project]];
        }
        NSLog(@"%@",responseObject);
        success(operation, projects);
    } failure:failure];
}

- (void) setProjectID: (NSInteger) projectID
              success:(void (^)(AFHTTPRequestOperation *operation, PIProject* project))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *parameters = @{@"active_project": [NSString stringWithFormat:@"%ld",(long)projectID] };
    [self postResource:@"projects/active_project" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, [self projectFromDic:responseObject]);
    } failure:failure];
}

#pragma mark - Projects - Helpers

- (PIProject*) projectFromDic:(NSDictionary*) projectDic
{
    PIProject* project = [[PIProject alloc] init];
    project.name = [projectDic objectForKey:@"name"];
    project.ID = [[projectDic objectForKey:@"id"] integerValue];
    project.description = [projectDic objectForKey:@"description"];
    //FIXME: Start
    //FIXME: End
    return project;
}


#pragma mark - Login

- (void) loginWithParameters: (NSDictionary*) parameters
                     success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self postResource:@"/sessions/create" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, [self userFromDic:responseObject]);
    } failure:failure];
}



#pragma mark - Users

- (void) getUsersOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* users))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"users" parameters:nil success:^(AFHTTPRequestOperation *operation, id usersDic) {
        NSMutableArray* users = [[NSMutableArray alloc] init];
        for (NSDictionary* user in usersDic) {
            [users addObject:[self userFromDic:user]];
        }
        success(operation, users);
    } failure:failure];
}

- (void) createUser: (NSDictionary*) user
            success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self postResource:@"users" parameters:user success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,[self userFromDic:responseObject]);
    } failure:failure];
}

- (void) getUserFromID: (NSInteger) userID
               success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:[NSString stringWithFormat:@"users/%ld", (long)userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id userDic) {
        success(operation, [self userFromDic:userDic]);
    } failure:failure];
}

- (void) editUser: (NSInteger) userID
       parameters: (NSDictionary*) user
          success:(void (^)(AFHTTPRequestOperation *operation, PIUser* user))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self editResource:@"users" withID: userID parameters:user success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        success(operation,[self userFromDic:responseObject]);
    } failure:failure];
}

- (void) deleteUser: (NSInteger) userID
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self deleteResource:[NSString stringWithFormat:@"users/%ld",(long)userID] parameters:nil success:success failure:failure];
}

#pragma mark - Users - Helpers

- (PIUser*) userFromDic:(NSDictionary*) userDic
{
    NSDictionary* profile = [userDic objectForKey:@"profile"];
    
    PIProfile* p = [self profileFromDic:profile];
    
    PIUser* u = [[PIUser alloc] init];
    u.ID = [[userDic objectForKey:@"id"] intValue];
    u.login = [userDic objectForKey:@"login"];
    u.firstName = [userDic objectForKey:@"first_name"];
    u.lastName = [userDic objectForKey:@"last_name"];
    u.emailAddress = [userDic objectForKey:@"email_address"];
    u.phoneNumber = [userDic objectForKey:@"phone_number"];
    u.profile = p;
    
    return u;
}


#pragma mark - Profiles

- (void) getProfilesOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* profiles))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"profiles" parameters:nil success:^(AFHTTPRequestOperation *operation, id profilesDic) {
        NSMutableArray* profiles = [[NSMutableArray alloc] init];
        for (NSDictionary* profileDic in profilesDic) {
            [profiles addObject:[self profileFromDic:profileDic]];
        }
        success(operation, profiles);
    } failure:failure];
}

- (void) getProfileFromID:(NSInteger) profileID
                  success:(void (^)(AFHTTPRequestOperation *operation, PIProfile* profile))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:[NSString stringWithFormat:@"profiles/%ld", (long)profileID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, [self profileFromDic:responseObject]);
    } failure:failure];
}

#pragma mark - Profiles - Helpers

- (PIProfile*) profileFromDic:(NSDictionary*) profileDic
{
    PIProfile* p = [[PIProfile alloc] init];
    p.description = [profileDic objectForKey:@"description"];
    p.ID = [[profileDic objectForKey:@"id"] integerValue];
    p.accessLevel = [[profileDic objectForKey:@"access_level"] integerValue];
    return p;
}


#pragma mark - Resources


- (void) getDocumentsOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* pictures))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResources:@"Document" Onsuccess:success failure:failure];
}

- (void) getPicturesOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* pictures))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResources:@"Image" Onsuccess:success failure:failure];
}


#pragma mark - Resources Helpers

- (void) getResources:(NSString*) resourceName
            Onsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* documents))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"resources" parameters:@{@"type_of_content" : resourceName} success:^(AFHTTPRequestOperation *operation, id usersDic) {
        NSMutableArray* documents = [[NSMutableArray alloc] init];
        for (NSDictionary* doc in usersDic) {
            [documents addObject:[self resourceFromDic:doc]];
        }
        success(operation, documents);
    } failure:failure];
}

- (PIResource*) resourceFromDic:(NSDictionary*) resourceDic
{
    PIResource* res = [[PIResource alloc] init];
    res.ID = [[resourceDic objectForKey:@"ID"] integerValue];
    res.typeOfContent = [resourceDic objectForKey:@"type_of_content"];
    res.name = [resourceDic objectForKey:@"name"];
    res.URL = [resourceDic objectForKey:@"url"];
    return res;
}

#pragma mark - Read document

- (void) readDocumentAtIndexPath:(NSString*) path
                       Onsuccess:(void (^)(AFHTTPRequestOperation *operation, NSString* fullPath))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:URL];
    NSString* realFileName = [URL.pathComponents lastObject];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", [NSTemporaryDirectory() stringByAppendingPathComponent:[URL lastPathComponent]], realFileName];
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    op.outputStream =  [NSOutputStream outputStreamToFileAtPath:fullPath append:NO];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, fullPath);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"e%@",error);
    }];
    
    [op start];
}

#pragma mark - Wiki Sections

- (void) getSectionsOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* sections))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"sections" parameters:nil success:^(AFHTTPRequestOperation *operation, id sectionsDic) {
        NSMutableArray* Sections = [[NSMutableArray alloc] init];
        for (NSDictionary* sectionDic in sectionsDic) {
            [Sections addObject:[self sectionFromDic:sectionDic]];
        }
        success(operation, Sections);
    } failure:failure];
}

#pragma mark - Wiki Articles

- (void) getArticlesOnsuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* articles))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"articles" parameters:nil success:^(AFHTTPRequestOperation *operation, id articlesDic) {
        NSMutableArray* Articles = [[NSMutableArray alloc] init];
        for (NSDictionary* articleDic in articlesDic) {
            [Articles addObject:[self articleFromDic:articleDic]];
        }
        success(operation, Articles);
    } failure:failure];
}


#pragma mark - Wiki Helpers

- (PISection*) sectionFromDic:(NSDictionary*) sectionDic
{
    PISection* res = [[PISection alloc] init];
    res.ID = [[sectionDic objectForKey:@"id"] integerValue];
    res.title = [sectionDic objectForKey:@"name"];
    NSMutableArray* articles = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [sectionDic objectForKey:@"articles"]) {
        PIArticle* art = [self articleFromDic: dic];
        [articles addObject:art];
    }
    res.articles = articles;
    return res;
}

- (PIArticle*) articleFromDic:(NSDictionary*) articleDic
{
    PIArticle* res = [[PIArticle alloc] init];
    res.ID = [[articleDic objectForKey:@"ID"] integerValue];
    res.title = [articleDic objectForKey:@"name"];
    res.content = [articleDic objectForKey:@"content"];
    res.section_id = [[articleDic objectForKey:@"section_id"] integerValue];
    return res;
}

#pragma mark - Roadmap

- (void) getRoadmapOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* tasks, NSInteger progress))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"roadmap/index" parameters:Nil success:^(AFHTTPRequestOperation *operation, id roadmapDic) {
        NSLog(@"%@",roadmapDic);
        NSDictionary* tasksDic = [roadmapDic objectForKey:@"tasks"];
        NSInteger progres = [[roadmapDic objectForKey:@"progress"] integerValue];
        NSMutableArray* tasks = [[NSMutableArray alloc] init];
        for (NSDictionary *taskDic in tasksDic) {
            [tasks addObject:[self taskFromDic:taskDic]];
        }
        success(operation,tasks, progres);

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Tasks

- (void) getTasksOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* tasks))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"tasks" parameters:nil success:^(AFHTTPRequestOperation *operation, id tasksDic) {
        NSMutableArray* tasks = [[NSMutableArray alloc] init];
        for (NSDictionary *taskDic in tasksDic) {
            [tasks addObject:[self taskFromDic:taskDic]];
        }
        success(operation, tasks);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void) getTaskWithId:(NSInteger) taskID
             OnSuccess:(void (^)(AFHTTPRequestOperation *operation, PITask* task))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:[NSString stringWithFormat:@"tasks/%ld", (long)taskID] parameters:nil success:^(AFHTTPRequestOperation *operation, id taskDic) {
        success(operation, [self taskFromDic:taskDic]);
    } failure:failure];
}


- (void) createTask:(NSDictionary *)task success:(void (^)(AFHTTPRequestOperation * operation, PITask* task))success
            failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self postResource:@"tasks" parameters:task success:^(AFHTTPRequestOperation *operation, id taskDic) {
        success(operation,[self taskFromDic:taskDic]);
    } failure:failure];
}

- (void) editTask: (NSInteger) taskID
       parameters: (NSDictionary*) TaskDic
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self editResource:@"tasks" withID: taskID parameters:TaskDic success:success failure:failure];
}

- (void) deleteTask: (NSInteger) taskID
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self deleteResource:[NSString stringWithFormat:@"tasks/%ld",(long)taskID] parameters:nil success:success failure:failure];
}


#pragma mark - Tasks Helpers


- (PITask*) taskFromDic:(NSDictionary*) taskDic
{
    PITask* res = [[PITask alloc] init];
    res.ID =  [[taskDic objectForKey:@"id"] integerValue];
    res.name = [taskDic objectForKey:@"name"];
    res.description = [taskDic objectForKey:@"description"];
    res.status = [taskDic objectForKey:@"status"];
    res.progress = [[taskDic objectForKey:@"progress"] integerValue];
    res.priority = [taskDic objectForKey:@"priority"];
    res.features = [[NSMutableArray alloc] init];
    res.bugs = [[NSMutableArray alloc] init];
    for (NSDictionary* featureDic in [taskDic objectForKey:@"features"]) {
        [res.features addObject:[self featureFromDic:featureDic]];
    }
    for (NSDictionary* featureBug in [taskDic objectForKey:@"bugs"]) {
        [res.bugs addObject:[self bugFromDic:featureBug]];
    }
    return res;
}


#pragma mark - Features

- (void) getFeaturesOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* features))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"features" parameters:nil success:^(AFHTTPRequestOperation *operation, id featuresDic) {
        NSMutableArray* features = [[NSMutableArray alloc] init];
        for (NSDictionary *featureDic in featuresDic) {
            [features addObject:[self taskFromDic:featureDic]];
        }
        success(operation, features);
    } failure:failure];
}


- (void) createFeature:(NSDictionary *)feature success:(void (^)(AFHTTPRequestOperation* operation, PIFeature* feature))success
           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self postResource:@"features" parameters:feature success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,[self featureFromDic:responseObject]);
    } failure:failure];
}

- (void) editFeature: (NSInteger) featureID
      parameters: (NSDictionary*) featureDic
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self editResource:@"features" withID: featureID parameters:featureDic success:success failure:failure];
}

- (void) deleteFeature: (NSInteger) featureID
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self deleteResource:[NSString stringWithFormat:@"features/%ld",(long)featureID] parameters:nil success:success failure:failure];
}


#pragma mark - Feature Helper

- (PIFeature*) featureFromDic:(NSDictionary*) featureDic
{
    PIFeature* res = [[PIFeature alloc] init];
    res.ID =  [[featureDic objectForKey:@"id"] integerValue];
    res.responsable = [self userFromDic:[featureDic objectForKey:@"user"]];
    res.type = [featureDic objectForKey:@"type_of_content"];
    res.name = [featureDic objectForKey:@"name"];
    res.description = [featureDic objectForKey:@"description"];
    res.status = [featureDic objectForKey:@"status"];
    res.priority = [featureDic objectForKey:@"priority"];
    res.progress = [[featureDic objectForKey:@"progress"] integerValue];
    res.released = [featureDic objectForKey:@"release"];
    res.estimation = [Tools timeFromDateTimeString:[featureDic objectForKey:@"estimation"]];
    res.spent_time = [Tools timeFromDateTimeString:[featureDic objectForKey:@"spent"]];
    res.user_id = [[featureDic objectForKey:@"user_id"] intValue];
    res.task_id = [[featureDic objectForKey:@"task_id"] intValue];
    return res;
}


#pragma mark - Bugs

- (void) getBugsOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* features))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"bugs" parameters:nil success:^(AFHTTPRequestOperation *operation, id bugsDic) {
        NSMutableArray* bugs = [[NSMutableArray alloc] init];
        for (NSDictionary *bugDic in bugsDic) {
            [bugs addObject:[self bugFromDic:bugDic]];
        }
        success(operation, bugs);
    } failure:failure];
}

- (void) createBug:(NSDictionary *)bug success:(void (^)(AFHTTPRequestOperation* operation, PIBug* bug))success
            failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self postResource:@"bugs" parameters:bug success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,[self bugFromDic:responseObject]);
    } failure:failure];
}

- (void) editBug: (NSInteger) bugID
       parameters: (NSDictionary*) bugDic
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self editResource:@"bugs" withID: bugID parameters:bugDic success:success failure:failure];
}

- (void) deleteBug: (NSInteger) bugID
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self deleteResource:[NSString stringWithFormat:@"bugs/%ld",(long)bugID] parameters:nil success:success failure:failure];
}

#pragma mark - Bug Helper

- (PIBug*) bugFromDic:(NSDictionary*) bugDic
{
    PIBug* res = [[PIBug alloc] init];
    res.ID =  [[bugDic objectForKey:@"id"] integerValue];
    res.responsable = [self userFromDic:[bugDic objectForKey:@"user"]];
    res.task = [self taskFromDic:[bugDic objectForKey:@"task"]];
    res.type = [bugDic objectForKey:@"type_of_content"];
    res.name = [bugDic objectForKey:@"name"];
    res.description = [bugDic objectForKey:@"description"];
    res.status = [bugDic objectForKey:@"status"];
    res.priority = [bugDic objectForKey:@"priority"];
    res.progress = [[bugDic objectForKey:@"progress"] integerValue];
    res.released = [bugDic objectForKey:@"release"];
    res.estimation = [Tools timeFromDateTimeString:[bugDic objectForKey:@"estimation"]];
    res.spent_time = [Tools timeFromDateTimeString:[bugDic objectForKey:@"spent"]];
    res.user_id = [[bugDic objectForKey:@"user_id"] intValue];
    res.task_id = [[bugDic objectForKey:@"task_id"] intValue];

    return res;
}

- (void) getEventsOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSMutableArray* events))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getResource:@"events" parameters:nil success:^(AFHTTPRequestOperation *operation, id eventsDic) {
        NSMutableArray* events = [[NSMutableArray alloc] init];
        for (NSDictionary *eventDic in eventsDic) {
            [events addObject:[self eventFromDic:eventDic]];
        }
        success(operation, events);
    } failure:failure];
}

- (void) createEvent:(NSDictionary *)event success:(void (^)(AFHTTPRequestOperation* operation, PIEvent* event))success
             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [self postResource:@"events" parameters:event success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,[self eventFromDic:responseObject]);
    } failure:failure];
}


- (void) editEvent: (NSInteger) eventID
        parameters: (NSDictionary*) eventDic
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self editResource:@"events" withID: eventID parameters:eventDic success:success failure:failure];
}

- (void) deleteEvent: (NSInteger) eventID
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self deleteResource:[NSString stringWithFormat:@"events/%ld",(long)eventID] parameters:nil success:success failure:failure];
}

#pragma mark - Bug Helper

+ (NSDateFormatter *)rfc822Formatter {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:enUS];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    }
    return formatter;
}

- (PIEvent*) eventFromDic:(NSDictionary*) eventDic
{    
    NSDateFormatter *dateFormatter = [NSDateFormatter rfc822Formatter];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    PIEvent* res = [[PIEvent alloc] init];
    res.ID = [[eventDic objectForKey:@"id"] integerValue];
    res.start = [dateFormatter dateFromString:[eventDic objectForKey:@"start"]];
    res.end = [dateFormatter dateFromString:[eventDic objectForKey:@"end"]];
    res.title = [eventDic objectForKey:@"title"];
    res.project_id = [[eventDic objectForKey:@"project_id"] intValue];
    return res;
}

@end

