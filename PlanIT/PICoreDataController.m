//
//  PICoreDataController.m
//  PlanIt
//
//  Created by Irenicus on 16/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PICoreDataController.h"

#import "PIProfile.h"
#import "PIUser.h"
#import "PIProject.h"

#import "PICProfile.h"
#import "PICProject.h"
#import "PICAccount.h"

@interface PICoreDataController ()


@end

@implementation PICoreDataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance {
    static dispatch_once_t once;
    static PICoreDataController *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PlanIt" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PlanIt.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark Accounts

- (PICAccount*) getLastAccount
{
    return [self getLastEntity:@"PICAccount"];
}

- (void) addAccountFromUser:(PIUser*) user withPassword:(NSString*) password
{
    NSManagedObjectContext* context = [self managedObjectContext];
    
    NSEntityDescription *profileEntity = [NSEntityDescription entityForName:@"PICProfile" inManagedObjectContext:context];
    PICProfile* profile = [[PICProfile alloc] initWithEntity:profileEntity insertIntoManagedObjectContext:context];
    
    profile.desc = user.profile.description;
    profile.id = [NSNumber numberWithInteger:user.profile.ID];
    profile.access_level = [NSNumber numberWithInteger:user.profile.accessLevel];
    
    NSEntityDescription *accountEntity = [NSEntityDescription entityForName:@"PICAccount" inManagedObjectContext:context];
    PICAccount* account = [[PICAccount alloc] initWithEntity:accountEntity insertIntoManagedObjectContext:context];
    
    account.login = user.login;
    account.password = password;
    account.email_address = user.emailAddress;
    account.first_name = user.firstName;
    account.last_name = user.lastName;
    account.phone_number = user.phoneNumber;
    account.profile = profile;
    
    NSError *error;
    [context save:&error];
}

#pragma mark getLastProject

- (PICProject*) getLastProject
{
    return [self getLastEntity:@"PICProject"];
}

- (void) addPICProjectFromProject:(PIProject*) project
{
    NSManagedObjectContext* context = [self managedObjectContext];

    NSEntityDescription *projectEntity = [NSEntityDescription entityForName:@"PICProject" inManagedObjectContext:context];
    PICProject* cproject = [[PICProject alloc] initWithEntity:projectEntity insertIntoManagedObjectContext:context];
    
    cproject.id = [NSNumber numberWithInteger:project.ID];
    cproject.desc = project.description;
    cproject.name = project.name;
    
    NSError *error;
    [context save:&error];

}

- (id) getLastEntity:(NSString*) entityStr
{
    NSError *error;
    NSManagedObjectContext* context = [self managedObjectContext];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityStr inManagedObjectContext:context];
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:entity];
	NSArray *array = [context executeFetchRequest:fetch error:&error];
    if ([array count ] > 0) {
        return [array firstObject];
    }
    return nil;
}


#pragma mark delete all Entities

- (BOOL)clearEntity:(NSString *)entity
{
    NSManagedObjectContext* context = [self managedObjectContext];
    
    NSFetchRequest *fetchAllObjects = [[NSFetchRequest alloc] init];
    [fetchAllObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    [fetchAllObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError *error = nil;
    NSArray *allObjects = [context executeFetchRequest:fetchAllObjects error:&error];
    if (error) {
        NSLog(@"CoreData Error :%@", error);
    }
    
    for (NSManagedObject *object in allObjects) {
        [context deleteObject:object];
    }

    NSError *saveError = nil;
    if (![context save:&saveError]) {
        NSLog(@"CoreData Save Error :%@", error);
    }
    return (saveError == nil);
}




#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
