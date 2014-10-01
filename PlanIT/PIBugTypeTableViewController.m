//
//  BugTypeTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 16/07/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIBugTypeTableViewController.h"

@interface PIBugTypeTableViewController ()

@end

@implementation PIBugTypeTableViewController
@synthesize delegate = _delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* selectedLabel;
    switch (indexPath.row) {
        case 0:
            selectedLabel = self.coreLabel.text;
            break;
        case 1:
            selectedLabel = self.criticalLabel.text;
            break;
        case 2:
            selectedLabel = self.uiLabel.text;
            break;
        default:
            selectedLabel = self.notDefinedLabel.text;
            break;
    }
    [_delegate setActiveType:selectedLabel];
}

@end
