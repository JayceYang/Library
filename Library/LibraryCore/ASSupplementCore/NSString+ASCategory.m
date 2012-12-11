//
//  NSString+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-11.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSString+ASCategory.h"
#import "NSDate+ASCategory.h"

@implementation NSString (ASCategory)

- (NSDate *)dateValueWithDateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:self];
}

- (NSString *)gender
{
    NSString *result = @"M";
    NSUInteger length = [self length];
    if (!([self characterAtIndex:length - 2] % 2)) {
        result = @"F";
    }
    return result;
}

- (NSDate *)birthday
{
    NSUInteger length = [self length];
    NSString *birthday = nil;
    if (length == 18) {
        birthday = [self substringWithRange:NSMakeRange(6, 8)];
    } else if (length == 15) {
        birthday = [NSString stringWithFormat:@"%d%@",19,[self substringWithRange:NSMakeRange(6, 6)]];
    }
    return [self dateValueWithDateFormat:kDateFormatNatural];
}

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
