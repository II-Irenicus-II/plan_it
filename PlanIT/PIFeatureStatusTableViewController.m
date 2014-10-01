//
//  StatusTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIFeatureStatusTableViewController.h"

@implementation PIFeatureStatusTableViewController

@synthesize delegate = _delegate;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* selectedLabel;
    switch (indexPath.row) {
        case 1:
            selectedLabel = self.startedLabel.text;
            break;
        case 2:
            selectedLabel = self.inProgressLabel.text;
            break;
        case 3:
            selectedLabel = self.doneLabel.text;
            break;
        case 4:
            selectedLabel = self.acceptedLabel.text;
            break;
        default:
            selectedLabel = self.notStartedLabel.text;
            break;
    }
    [_delegate setActiveStatus:selectedLabel];
}

@end
