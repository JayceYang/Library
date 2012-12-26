//
//  NSObject+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-25.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ASLog
#if DEBUG
#define ASLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ASLog(fmt, ...)
#endif
#endif

#define SystemVersionGreaterThanOrEqualTo(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define SystemVersionGreaterThanOrEqualTo5 SystemVersionGreaterThanOrEqualTo(5.0f)

BOOL doubleEqualToDouble(double double1, double double2);
BOOL doubleEqualToDoubleWithAccuracyExponent(double double1, double double2 ,int accuracyExponent);

@interface NSObject (ASCategory)

- (NSInteger)integerValueFromValue:(id)value;
- (BOOL)boolValueFromValue:(id)value;
- (NSString *)stringValueFromValue:(id)value;
- (NSDictionary *)dictionaryValueFromValue:(id)value;

- (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key;
- (NSString *)bundleVersion;

/* load from main bundle, no cache */
- (UIImage *)imageWithContentsOfFileNamed:(NSString *)name;
- (UIImage *)imageFromView:(UIView *)view;
- (UIImage *)imageFromColor:(UIColor *)color;

@end
