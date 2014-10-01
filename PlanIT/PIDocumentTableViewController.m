//
//  DocumentController.m
//  PlanIt
//
//  Created by Irenicus on 21/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIDocumentTableViewController.h"
#import "PICustomPreviewItem.h"

#import "PIClientAPI.h"

#import "PIResource.h"

@implementation PIDocumentTableViewController
{
    NSString* docName;
}

@synthesize documents = _documents;

- (void) viewDidLoad
{
    [super viewDidLoad];
    _documents = [[NSMutableArray alloc] init];
    [[PIClientAPI sharedInstance] getDocumentsOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *documents) {
        _documents = documents;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}

// DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PIResource *doc = [self.documents objectAtIndex:indexPath.row];
    cell.textLabel.text = doc.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.documents count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIResource* res = [self.documents objectAtIndex:indexPath.row];
    
    [[PIClientAPI sharedInstance] readDocumentAtIndexPath:res.URL Onsuccess:^(AFHTTPRequestOperation *operation, NSString *fullPath) {
        self.currentDocLocation = fullPath;
        PIResource *doc = [self.documents objectAtIndex:indexPath.row];
        docName = doc.name;

        QLPreviewController* preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        [self.navigationController presentViewController:preview animated:YES completion:^(void){}];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark QLPreviewControllerDataSource

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    
    PICustomPreviewItem* item = [[PICustomPreviewItem  alloc] init];
    
    item.previewItemURL = [NSURL fileURLWithPath:self.currentDocLocation];
    item.previewItemTitle = docName;

    
    return item;
    
}


@end
