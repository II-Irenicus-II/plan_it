//
//  Project.h
//  PlanIt
//
//  Created by Irenicus on 27/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIProject : NSObject

@property NSInteger ID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSDate* start;
@property (nonatomic, retain) NSDate* end;
@property NSInteger acces_level;


@end
