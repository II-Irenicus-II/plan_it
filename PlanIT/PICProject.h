//
//  PICProject.h
//  PlanIt
//
//  Created by Irenicus on 12/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PICProject : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;

@end
