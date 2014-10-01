//
//  GalleryControllerViewController.m
//  PlanIt
//
//  Created by Irenicus on 14/06/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import "PIGalleryController.h"

#import "PIClientAPI.h"

#import "PIResource.h"

#import "PIGalleryCell.h"
#import "PIImageViewController.h"

@interface PIGalleryController ()
{
    UIImage* selectedPicture;
}

@end

@implementation PIGalleryController

@synthesize pictures = _pictures;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PIClientAPI sharedInstance] getPicturesOnsuccess:^(AFHTTPRequestOperation *operation, NSMutableArray *pictures) {
        _pictures = pictures;
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_pictures count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PIGalleryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"imagesCell" forIndexPath:indexPath];
    PIResource* picture= [_pictures objectAtIndex:indexPath.row];
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picture.URL]];
    UIImage* min_image = [[UIImage alloc] initWithData:imageData];
    [cell setImage:min_image];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PIResource* picture = [_pictures objectAtIndex:indexPath.row];
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picture.URL]];
    selectedPicture = [[UIImage alloc] initWithData:imageData];
    [self performSegueWithIdentifier:@"segueImageDetail" sender:self];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PIImageViewController *dest = [segue destinationViewController];
    dest.image = selectedPicture;
}

@end
