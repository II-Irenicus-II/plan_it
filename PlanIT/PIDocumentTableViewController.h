//
//  DocumentController.h
//  PlanIt
//
//  Created by Irenicus on 21/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface PIDocumentTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, retain) NSMutableArray* documents;
@property (nonatomic, retain) NSString* currentDocLocation;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
