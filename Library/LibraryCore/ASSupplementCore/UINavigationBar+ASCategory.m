//
//  UINavigationBar+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-9-3.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "UINavigationBar+ASCategory.h"
#import "UIView+ASCategory.h"
#import "NSObject+ASCategory.h"

@implementation UINavigationBar (ASCategory)

- (void)setBackgroundImageWithColor:(UIColor *)color
{
    if (SystemVersionGreaterThanOrEqualTo5) {
        [self setBackgroundImage:[self imageFromColor:color] forBarMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[self imageFromColor:color] forBarMetrics:UIBarMetricsLandscapePhone];
    } else {
        [self setTintColor:color];
    }
}

@end
