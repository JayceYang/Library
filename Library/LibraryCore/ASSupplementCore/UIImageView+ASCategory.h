//
//  UIImageView+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-12.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ASCategory)

- (CGFloat)constrainedToWidth:(CGFloat)width originalWidth:(CGFloat)originalWidth originalHeight:(CGFloat)originalHeight;
- (CGFloat)constrainedToHeight:(CGFloat)height originalWidth:(CGFloat)originalWidth originalHeight:(CGFloat)originalHeight;

@end
