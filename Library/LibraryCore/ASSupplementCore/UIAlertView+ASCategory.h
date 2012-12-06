//
//  UIAlertView+ASCategory.h
//  ASSupplement
//
//  Created by Yang Jayce on 12-5-15.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (ASCategory)

/* prevent multiple UIAlertView alerts from popping up at once */
- (void)showElegantly;

@end
