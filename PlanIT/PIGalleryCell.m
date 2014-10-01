//
//  GalleryCell.m
//  PlanIt
//
//  Created by Irenicus on 14/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIGalleryCell.h"

@implementation PIGalleryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) setImage:(UIImage*) image
{
    imageView.image = image;
}


@end
