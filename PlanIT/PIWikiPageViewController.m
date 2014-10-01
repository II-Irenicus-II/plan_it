//
//  WikiPageViewController.m
//  PlanIt
//
//  Created by Irenicus on 06/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIWikiPageViewController.h"

#import "PIArticle.h"
#import "PISection.h"

@interface PIWikiPageViewController ()

@end

@implementation PIWikiPageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData
{
    self.navigationItem.title = [[NSString alloc] initWithFormat:@"%@ - %@", self.section.title, self.article.title];
    [self.webView loadHTMLString:self.article.content baseURL:nil];
}


@end
