//
//  PICProfile.h
//  PlanIt
//
//  Created by Irenicus on 27/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PICProfile : NSManagedObject

@property (nonatomic, retain) NSNumber * access_level;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSManagedObject *account;

@end
