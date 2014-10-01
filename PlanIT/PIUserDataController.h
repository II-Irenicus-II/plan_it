//
//  PIUserDataController.h
//  PlanIt
//
//  Created by Irenicus on 26/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIUser, PIProfile;

@interface PIUserDataController : NSObject

@property (nonatomic, retain) NSMutableArray* userList;


- (void)initializeUserListOnComplete:(void(^)(void))complete;

- (NSInteger)countOfList;

- (PIUser*)userInListAtIndex:(NSInteger)index;


- (void)createUserWithLogin:(NSString*) login
                   Password:(NSString*) password
                  FirstName:(NSString*) firstName
                   LastName:(NSString*) lastName
               EmailAddress:(NSString*) emailAddress
                PhoneNumber:(NSString*) phoneNumber
                  ProfileID:(NSInteger) profileID
                   callBack:(void(^)(void))callback;

- (void) addUserToList: (PIUser*) user;

- (void) replaceUserAtIndex: (NSInteger) row byUser: (PIUser*) user;


- (void)editUserWitID:(NSInteger) ID
               SetLogin:(NSString*) login
            SetPassword:(NSString*) password
           SetFirstName:(NSString*) firstName
            SetLastName:(NSString*) lastName
        SetEmailAddress:(NSString*) emailAddress
         SetphoneNumber:(NSString*) phoneNumber
           SetProfileID:(NSInteger) profileID
             callBack:(void(^)(void))callback;


- (void) deleteUserAtRow: (NSInteger) row onSuccess:(void(^)(void))callback;

@end
