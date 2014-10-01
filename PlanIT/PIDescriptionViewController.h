//
//  FeatureDescriptionController.h
//  PlanIt
//
//  Created by Irenicus on 29/05/13.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PIDescriptionViewControllerDelegate;


@interface PIDescriptionViewController: UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, retain) id<PIDescriptionViewControllerDelegate> delegate;


@end


@protocol PIDescriptionViewControllerDelegate <NSObject>

- (void) setDescription:(NSString*) description;
- (NSString*) getDescription;


@end