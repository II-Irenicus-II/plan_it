//
//  Ressource.h
//  PlanIt
//
//  Created by Irenicus on 21/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIResource : NSObject

@property  NSInteger ID;
@property (nonatomic, retain) NSString* URL;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* typeOfContent;

@end
