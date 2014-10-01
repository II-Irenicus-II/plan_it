//
//  Tools.h
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PIProject;
@interface Tools : NSObject

+ (NSTimeInterval) timeFromDateTimeString: (NSString*) str;

+ (NSString*) stringHourAndMinutesFromTimeInterval: (NSTimeInterval) timeInterval;

+ (NSDate*) dateFormatedToCalendarFromDate: (NSDate*) date;

+ (void) setActiveProjectCallBack:(void(^)(NSMutableArray* projects, PIProject* projectSelected))callback;


@end
