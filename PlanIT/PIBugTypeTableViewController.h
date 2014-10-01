//
//  BugTypeTableViewController.h
//  PlanIt
//
//  Created by Irenicus on 16/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIBugTypeTableViewControllerDelegate;



@interface PIBugTypeTableViewController : UITableViewController


@property (nonatomic, unsafe_unretained) id<PIBugTypeTableViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *coreLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticalLabel;
@property (weak, nonatomic) IBOutlet UILabel *uiLabel;
@property (weak, nonatomic) IBOutlet UILabel *notDefinedLabel;


@end


@protocol PIBugTypeTableViewControllerDelegate <NSObject>

- (void) setActiveType:(NSString*) type;

@end