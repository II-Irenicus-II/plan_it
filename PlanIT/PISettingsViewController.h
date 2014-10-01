//
//  SettingsViewController.h
//  PlanIt
//
//  Created by Irenicus on 10/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIProjectSelectorController.h"

@interface PISettingsViewController : UITableViewController <PIProjectSelectorControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;

@property (nonatomic, retain) NSArray* projects;

@end
