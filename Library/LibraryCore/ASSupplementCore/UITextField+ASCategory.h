//
//  UITextField+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-7.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ASCategory)

- (UIView *)roundedRectBackgroundView;
- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius paddingWidth:(CGFloat)paddingWidth;

@end
