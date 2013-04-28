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

- (BOOL)matchWithPattern:(NSString *)pattern
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isValidNumber
{
    NSString *pattern = @"^[0-9]*$";
    return [self matchWithPattern:pattern];
}

- (BOOL)isValidEmail
{
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchWithPattern:pattern];
}

- (BOOL)isValidMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *pattern = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    return [self matchWithPattern:pattern];
}

- (BOOL)isValidaCarPlate
{
    NSString *pattern = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    return [self matchWithPattern:pattern];
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
    return [birthday dateValueWithDateFormat:kDateFormatNatural];
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

- (CGFloat)heightWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGFloat result = [self sizeWithFont:font constrainedToSize:size].height;
    return result;
}

@end
