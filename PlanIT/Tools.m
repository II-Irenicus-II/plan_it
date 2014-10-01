//
//  Tools.m
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "Tools.h"

#import "PIClientAPI.h"
#import "PICoreDataController.h"

#import "PICProject.h"

@implementation Tools

+ (NSTimeInterval) timeFromDateTimeString: (NSString*) str
{
    if (str == nil) {
        return 0;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSDate *estimationDate = [dateFormatter dateFromString:str];
    NSDate *reference = [dateFormatter dateFromString:@"2000-01-01T00:00:00Z"];
    return [estimationDate timeIntervalSinceDate:reference];
}

+ (NSString*) stringHourAndMinutesFromTimeInterval: (NSTimeInterval) timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSDate*) dateFormatedToCalendarFromDate: (NSDate*) date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                 fromDate:date];
    [components setHour: 0];
    [components setMinute: 0];
    [components setSecond: 0];
    NSDate *result = [calendar dateFromComponents:components];
    return result;
}

+ (void) setActiveProjectCallBack:(void(^)(NSMutableArray* projects, PIProject* projectSelected))callback
{
    [[PIClientAPI sharedInstance] getProjectsOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *projects) {
        PICProject* storeProj = [[PICoreDataController sharedInstance] getLastProject];
        NSInteger ID = [[storeProj id] integerValue];
        if (storeProj == nil) {
            if ([projects count] > 0) {
                PIProject * firstPro = [projects firstObject];
                callback(projects, firstPro);
            } else {
                callback(projects, nil);
            }
        } else {
            [[PIClientAPI sharedInstance] setProjectID:ID success:^(AFHTTPRequestOperation *operation, PIProject* projet) {
                callback(projects, projet);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // fixme can't reach server
        
    }];
}

@end
