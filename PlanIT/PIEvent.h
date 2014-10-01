//
//  Event.h
//  PlanIt
//
//  Created by Irenicus on 24/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIEvent : NSObject


@property NSInteger ID;
@property NSInteger project_id;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSDate* start;
@property (nonatomic, retain) NSDate* end;

@end
