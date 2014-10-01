//
//  PIUserDataController.m
//  PlanIt
//
//  Created by Irenicus on 26/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>

#import "PIUserDataController.h"
#import "PIClientAPI.h"
#import "PIUser.h"
#import "PIProfile.h"

@interface PIUserDataController ()

@end

@implementation PIUserDataController
@synthesize userList = _userList;

- (id)init
{
    self = [super init];
    if (self) {
        _userList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initializeUserListOnComplete:(void(^)(void))complete
{
    [_userList removeAllObjects];
    [[PIClientAPI sharedInstance] getUsersOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *users) {
        _userList =  users;
        complete();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}


- (NSInteger) countOfList
{
    return [_userList count];
}

- (PIUser*)userInListAtIndex:(NSInteger)index
{
    return [_userList objectAtIndex:index];
}

- (void)createUserWithLogin:(NSString*) login
            Password:(NSString*) password
           FirstName:(NSString*) firstName
            LastName:(NSString*) lastName
        EmailAddress:(NSString*) emailAddress
         PhoneNumber:(NSString*) phoneNumber
           ProfileID:(NSInteger) profileID
            callBack:(void(^)(void))callback
{
    NSDictionary* userDic = @{
                              @"login": login,
                              @"password": password,
                              @"first_name": firstName,
                              @"last_name": lastName,
                              @"email_address": emailAddress,
                              @"phone_number": phoneNumber,
                              @"profile_id": [NSString stringWithFormat:@"%ld",(long)profileID]
                              };
    NSDictionary* form = [[NSDictionary alloc] initWithObjectsAndKeys: userDic, @"user", nil];
    [[PIClientAPI sharedInstance] createUser:form success:^(AFHTTPRequestOperation *operation, PIUser* user) {
        [self addUserToList:user];
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
}

- (void) addUserToList: (PIUser*) user
{
    [_userList addObject:user];
}

- (void) replaceUserAtIndex: (NSInteger) row byUser: (PIUser*) user
{
    [_userList replaceObjectAtIndex:row withObject:user];
}


- (void)editUserWitID:(NSInteger) ID
             SetLogin:(NSString*) login
          SetPassword:(NSString*) password
         SetFirstName:(NSString*) firstName
          SetLastName:(NSString*) lastName
      SetEmailAddress:(NSString*) emailAddress
       SetphoneNumber:(NSString*) phoneNumber
         SetProfileID:(NSInteger) profileID
             callBack:(void(^)(void))callback

{
    
    NSDictionary* userDic = @{
                              @"login": login,
                              @"first_name": firstName,
                              @"last_name": lastName,
                              @"email_address": emailAddress,
                              @"phone_number": phoneNumber,
                              @"profile_id": [NSString stringWithFormat:@"%ld",(long)profileID]
                              };
    NSDictionary* form = [[NSDictionary alloc] initWithObjectsAndKeys: userDic, @"user", nil];
    [[PIClientAPI sharedInstance] editUser:ID parameters:form success:^(AFHTTPRequestOperation *operation, PIUser* user) {
        NSInteger i = 0;
        for (PIUser* u in _userList) {
            if (u.ID == user.ID) {
                u.firstName = user.firstName;
                u.lastName = user.lastName;
                u.profile = user.profile;
                u.emailAddress = user.emailAddress;
                u.phoneNumber = user.phoneNumber;
            }
            i++;
        }
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

- (void) deleteUserAtRow: (NSInteger) row onSuccess:(void(^)(void))callback
{
    NSInteger userID = [[self userInListAtIndex:row] ID];
    [[PIClientAPI sharedInstance] deleteUser:userID success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [_userList removeObjectAtIndex:row];
        callback();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"FIXME : error."];
        NSLog(@"Connection : Failure \n%@",error);
    }];
}

@end
