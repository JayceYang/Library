//
//  NSString+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-11.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSString+ASCategory.h"

@implementation NSString (ASCategory)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    CGFloat result = 0;
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size = [self sizeWithFont:font constrainedToSize:constraint];
    result = size.height;
//    ASLog("%@\t%f\t%f",self,width,result);
    return result;
}

@end
