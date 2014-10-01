//
//  NSDateFormatter+dateFromRFC822.h
//  PlanIT
//
//  Created by Irenicus on 02/12/2013.
//  Copyright (c) 2013 PlanIT Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (RFC822)

+ (NSDateFormatter *)rfc822Formatter;

@end

@interface NSDate (RFC822)

+ (NSDate *)dateFromRFC822:(NSString *)date;

@end