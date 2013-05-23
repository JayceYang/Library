//
//  UIAlertView+ASCategory.h
//  Library
//
//  Created by Jayce Yang on 5/23/13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewHandler)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (ASCategory) <UIAlertViewDelegate>

- (void)showWithHandler:(UIAlertViewHandler)handler;

@end
