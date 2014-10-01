//
//  PICAccount.h
//  PlanIt
//
//  Created by Irenicus on 27/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PICProfile;

@interface PICAccount : NSManagedObject

@property (nonatomic, retain) NSString * email_address;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * phone_number;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) PICProfile *profile;

@end
