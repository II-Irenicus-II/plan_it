//
//  PILogoutSegue.m
//  PlanIT
//
//  Created by Irenicus on 02/12/2013.
//  Copyright (c) 2013 PlanIT Company. All rights reserved.
//

#import "PILogSegue.h"

@implementation PILogSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src presentViewController:dst animated:YES completion:NULL];
                    }
                    completion:NULL];
}

@end
