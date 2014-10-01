//
//  NSDateFormatter+dateFromRFC822.m
//  PlanIT
//
//  Created by Irenicus on 02/12/2013.
//  Copyright (c) 2013 PlanIT Company. All rights reserved.
//

#import "NSDateFormatter+RFC822.h"

@implementation NSDateFormatter (RFC822)

+ (NSDateFormatter *)rfc822Formatter {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:enUS];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    }
    return formatter;
}

@end


@implementation NSDate (RFC822)

+ (NSDate *)dateFromRFC822:(NSString *)date {
    NSDateFormatter *formatter = [NSDateFormatter rfc822Formatter];
    return [formatter dateFromString:date];
}

@end