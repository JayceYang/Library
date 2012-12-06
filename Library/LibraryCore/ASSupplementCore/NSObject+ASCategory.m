//
//  NSObject+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-25.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "NSObject+ASCategory.h"

inline BOOL doubleEqualToDouble(double double1, double double2)
{
    return fabs(double1 - double2) <= pow(10, - 6);
}

inline BOOL doubleEqualToDoubleWithAccuracyExponent(double double1, double double2 ,int accuracyExponent)
{
    return fabs(double1 - double2) <= pow(10, - accuracyExponent);
}

// -------------------------- Device Model -------------------------- //

#define kDeviceModel                        @"deviceModel"
#define kDeviceModelPad                     @"iPad"
#define kDeviceModelPhone                   @"iPhone"
#define kDeviceModelPod                     @"iPod touch"

@implementation NSObject (ASCategory)

- (BOOL)padDeviceModel
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO;
}

- (BOOL)retinaDisplaySupported
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)deviceModel
{
    if ([self padDeviceModel]) {
        return kDeviceModelPad;
    } else {
        return kDeviceModelPhone;
    }
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return 0;
    }
    
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)memoryUsedByCurrentTask
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return 0;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

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

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:string];
}

- (NSString *)thisYear
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatYearOnly];
}

- (NSString *)thisMonth
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatMonthOnly];
}

- (NSString *)theDateToday
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatTheDateTodayOnly];
}

- (NSString *)thisHour
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatHourOnly];
}

- (NSString *)thisMinute
{
    return [self stringFromDate:[NSDate date] dateFormat:kDateFormatMinuteOnly];
}

- (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate
{
    NSTimeInterval timeInterval = 60 * 60 * 24 * dayInterval;
    return [NSDate dateWithTimeInterval:timeInterval sinceDate:sinceDate];
}

- (NSDate *)midnightDateFromDate:(NSDate *)date
{
    NSString *dateOnly = [self stringFromDate:date dateFormat:kDateFormatSlash];
    NSString *timeOnly = @"00:00:00";
    NSString *newDate = [NSString stringWithFormat:@"%@ %@",dateOnly,timeOnly];
    return [self dateFromString:newDate dateFormat:kDateFormatSlashLong];
}

- (NSDate *)noondayFromDate:(NSDate *)date
{
    NSString *dateOnly = [self stringFromDate:date dateFormat:kDateFormatSlash];
    NSString *timeOnly = @"12:00:00";
    NSString *newDate = [NSString stringWithFormat:@"%@ %@",dateOnly,timeOnly];
    return [self dateFromString:newDate dateFormat:kDateFormatSlashLong];
}

- (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

- (NSString *)genderFromIDNumber:(NSString *)number
{
    NSString *result = @"M";
    NSUInteger length = [number length];
    if (!([number characterAtIndex:length - 2] % 2)) {
        result = @"F";
    }
    return result;
}

- (NSDate *)birthdayFromIDNumber:(NSString *)number
{
    NSUInteger length = [number length];
    NSString *birthday = nil;
    if (length == 18) {
        birthday = [number substringWithRange:NSMakeRange(6, 8)];
    } else if (length == 15) {
        birthday = [NSString stringWithFormat:@"%d%@",19,[number substringWithRange:NSMakeRange(6, 6)]];
    }
    return [self dateFromString:birthday dateFormat:kDateFormatNatural];
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
