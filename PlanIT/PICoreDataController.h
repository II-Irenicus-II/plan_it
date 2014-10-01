//
//  PICoreDataController.h
//  PlanIt
//
//  Created by Irenicus on 16/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PIUser, PIProfile, PICAccount, PICProject, PIProject;
@interface PICoreDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;

- (void)saveContext;


#pragma mark Accounts

- (PICAccount*) getLastAccount;


- (void) addAccountFromUser:(PIUser*) user withPassword:(NSString*) password;

#pragma markProject

- (PICProject*) getLastProject;

- (void) addPICProjectFromProject:(PIProject*) project;



#pragma mark delete all Entities

- (BOOL)clearEntity:(NSString *)entity;


- (NSURL *)applicationDocumentsDirectory;

@end
