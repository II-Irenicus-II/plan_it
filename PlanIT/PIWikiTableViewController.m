//
//  WikiTableViewController.m
//  PlanIt
//
//  Created by Irenicus on 06/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIWikiTableViewController.h"
#import "PIWikiPageViewController.h"

#import "PIClientAPI.h"

#import "PISection.h"
#import "PIArticle.h"

@interface PIWikiTableViewController ()

@end

@implementation PIWikiTableViewController
{
    PISection* selectedSection;
    PIArticle* selectedArticle;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _wikiSections = [[NSMutableArray alloc] init];
    [[PIClientAPI sharedInstance] getSectionsOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *sections) {
        self.wikiSections = sections;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.wikiSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.wikiSections objectAtIndex:section] articles] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.wikiSections objectAtIndex:section] title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"articleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.textLabel.text = [[[[self.wikiSections objectAtIndex:indexPath.section] articles] objectAtIndex:indexPath.row] title];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedSection = [self.wikiSections objectAtIndex:indexPath.section];
    selectedArticle = [[selectedSection articles] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showArticleSegue" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PIWikiPageViewController* wikiPage = [segue destinationViewController];
    wikiPage.article = selectedArticle;
    wikiPage.section = selectedSection;
}

@end
