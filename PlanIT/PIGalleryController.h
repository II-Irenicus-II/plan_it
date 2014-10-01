//
//  GalleryControllerViewController.h
//  PlanIt
//
//  Created by Irenicus on 14/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIGalleryController : UICollectionViewController

@property (nonatomic, retain) NSMutableArray* pictures;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
