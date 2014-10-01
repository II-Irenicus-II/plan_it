//
//  GalleryCell.h
//  PlanIt
//
//  Created by Irenicus on 14/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIGalleryCell : UICollectionViewCell
{
    IBOutlet UIImageView *imageView;
}

- (void) setImage:(UIImage*) image;

@end
