//
//  EditUserRightsController.h
//  PlanIt
//
//  Created by Irenicus on 18/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIUserRightsControllerDelegate;

@class Profile;
@interface PIUserRightsController : UITableViewController

@property (nonatomic, retain) NSArray* profiles;
@property (nonatomic, unsafe_unretained) id<PIUserRightsControllerDelegate> delegate;


@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end


@protocol PIUserRightsControllerDelegate <NSObject>

- (void) setActiveProfile:(Profile*) profile;

@end