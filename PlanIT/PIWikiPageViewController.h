//
//  WikiPageViewController.h
//  PlanIt
//
//  Created by Irenicus on 06/10/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PIArticle, PISection;
@interface PIWikiPageViewController : UIViewController

@property (retain, nonatomic) PIArticle* article;
@property (retain, nonatomic) PISection* section;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


- (void) reloadData;

@end
