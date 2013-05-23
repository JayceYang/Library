//
//  UIAlertView+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 5/23/13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import <objc/runtime.h>

#import "UIAlertView+ASCategory.h"

static char kHandlerAssociatedKey;

@implementation UIAlertView (ASCategory)

- (void)showWithHandler:(UIAlertViewHandler)handler
{
    objc_setAssociatedObject(self, kHandlerAssociatedKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self setDelegate:self];
    [self show];
}

#pragma mark - UIAlertViewDelegate

/*
 * Sent to the delegate when the user clicks a button on an alert view.
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertViewHandler completionHandler = objc_getAssociatedObject(self, kHandlerAssociatedKey);
    
    if (completionHandler != nil) {
        
        completionHandler(alertView, buttonIndex);
    }
}

@end
