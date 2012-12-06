//
//  NSObject+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-25.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL doubleEqualToDouble(double double1, double double2);
BOOL doubleEqualToDoubleWithAccuracyExponent(double double1, double double2 ,int accuracyExponent);

#ifndef ASLog
#if DEBUG
#define ASLog(fmt, ...) NSLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ASLog(fmt, ...)
#endif
#endif

#define SystemVersionGreaterThanOrEqualTo(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define SystemVersionGreaterThanOrEqualTo5 SystemVersionGreaterThanOrEqualTo(5.0f)

// -------------------------- Date Format -------------------------- //

#define kDateFormatYearOnly                 @"yyyy"
#define kDateFormatMonthOnly                @"MM"
#define kDateFormatTheDateTodayOnly         @"dd"
#define kDateFormatTimeOnly                 @"HH:mm:ss"
#define kDateFormatHourOnly                 @"HH"
#define kDateFormatMinuteOnly               @"mm"
#define kDateFormatChinese                  @"yyyy年MM月dd日"
#define kDateFormatNatural                  @"yyyyMMdd"
#define kDateFormatNaturalLong              @"yyyyMMddHHmmss"
#define kDateFormatHorizontalLine           @"yyyy-MM-dd"
#define kDateFormatHorizontalLineLong       @"yyyy-MM-dd HH:mm:ss"
#define kDateFormatSlash                    @"yyyy/MM/dd"
#define kDateFormatSlashLong                @"yyyy/MM/dd HH:mm:ss"
#define kDateFormatShortChinese             @"MM月dd日 HH:mm"

#define kExtensionPNG                       @"png"

@interface NSObject (ASCategory)

- (BOOL)padDeviceModel;
- (BOOL)retinaDisplaySupported;
- (NSString *)deviceModel;
- (double)availableMemory;  //(单位：MB）
- (double)memoryUsedByCurrentTask;   //(单位：MB）

- (NSInteger)integerValueFromValue:(id)value;
- (BOOL)boolValueFromValue:(id)value;
- (NSString *)stringValueFromValue:(id)value;
- (NSDictionary *)dictionaryValueFromValue:(id)value;

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format;
- (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format;
- (NSString *)thisYear;
- (NSString *)thisMonth;
- (NSString *)theDateToday;
- (NSString *)thisHour;
- (NSString *)thisMinute;
- (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate;
- (NSDate *)midnightDateFromDate:(NSDate *)date;
- (NSDate *)noondayFromDate:(NSDate *)date;

- (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key;

- (NSString *)genderFromIDNumber:(NSString *)number;    //male results "M", female returns "F"
- (NSDate *)birthdayFromIDNumber:(NSString *)number;    //returns the date with format like "yyyyMMdd"

/* load from main bundle, no cache */
- (UIImage *)imageWithContentsOfFileNamed:(NSString *)name;
- (UIImage *)imageFromView:(UIView *)view;
- (UIImage *)imageFromColor:(UIColor *)color;

@end
