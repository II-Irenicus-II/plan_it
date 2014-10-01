//
//  ImageViewController.m
//  PlanIt
//
//  Created by Irenicus on 14/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIImageViewController.h"

@interface PIImageViewController ()

@end

@implementation PIImageViewController
@synthesize image = _image;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.image;
    self.scrollView.contentSize = _image.size;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 100.0;
	// Do any additional setup after loading the view.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
