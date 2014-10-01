//
//  PICustomPreviewItem.h
//  PlanIt
//
//  Created by Irenicus on 14/11/2013.
//  Copyright (c) 2013 PlanIt Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>


@interface PICustomPreviewItem : NSObject<QLPreviewItem>

@property (readwrite) NSURL *previewItemURL;
@property (readwrite) NSString *previewItemTitle;

@end