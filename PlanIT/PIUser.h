//
//  User.h
//  PlanIt
//
//  Created by Irenicus on 12/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIProfile;
@interface PIUser : NSObject

@property NSInteger ID;
@property (nonatomic, retain) NSString* login;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSString* emailAddress;
@property (nonatomic, retain) NSString* phoneNumber;
@property (nonatomic, retain) PIProfile* profile;

@end
