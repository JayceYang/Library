//
//  NSObject+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-25.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NSObject+ASCategory.h"
#import "NSDate+ASCategory.h"

inline BOOL doubleEqualToDouble(double double1, double double2)
{
    return fabs(double1 - double2) <= pow(10, - 6);
}

inline BOOL doubleEqualToDoubleWithAccuracyExponent(double double1, double double2 ,int accuracyExponent)
{
    return fabs(double1 - double2) <= pow(10, - accuracyExponent);
}

@implementation NSObject (ASCategory)

- (NSInteger)integerValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    } else {
        return 0;
    }
}

- (BOOL)boolValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

- (NSString *)stringValueFromValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    } else {
        return [NSString string];
    }
}

- (NSDictionary *)dictionaryValueFromValue:(id)value
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return [NSDictionary dictionary];
    }
}

- (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

- (UIImage *)imageWithContentsOfFileNamed:(NSString *)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    if (filePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        return image;
    } else {
        return nil;
    }
}

- (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
