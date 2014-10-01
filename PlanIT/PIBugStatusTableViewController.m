//
//  StatusTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIBugStatusTableViewController.h"

@implementation PIBugStatusTableViewController

@synthesize delegate = _delegate;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* selectedLabel;
    switch (indexPath.row) {
        case 1:
            selectedLabel = self.inProgressLabel.text;
            break;
        case 2:
            selectedLabel = self.feedBackLabel.text;
            break;
        case 3:
            selectedLabel = self.closedLabel.text;
            break;
        case 4:
            selectedLabel = self.resolvedLabel.text;
            break;
        default:
            selectedLabel = self.notStartedLabel.text;
            break;
    }
    [_delegate setActiveStatus:selectedLabel];
}

@end
