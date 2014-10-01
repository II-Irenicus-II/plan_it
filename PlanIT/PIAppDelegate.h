//
//  AppDelegate.h
//  PlanIt
//
//  Created by Irenicus on 08/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;
@interface PIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Project* active_project;

@end
