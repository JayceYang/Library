//
//  NSDate+ASCategory.h
//  Library
//
//  Created by Jayce Yang on 12-12-7.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

// -------------------------- Date Format -------------------------- //

#define kDateFormatYearOnly                 @"yyyy"
#define kDateFormatMonthOnly                @"MM"
#define kDateFormatTheDateTodayOnly         @"dd"
#define kDateFormatTimeOnly                 @"HH:mm:ss"
#define kDateFormatTimeShortOnly            @"HH:mm"
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

@interface NSDate (ASCategory)


- (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate;
- (NSDate *)midnightDateFromDate:(NSDate *)date;
- (NSDate *)noondayFromDate:(NSDate *)date;

- (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format;
- (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format;
- (NSDate *)theDayBeforeYesterday;
- (NSDate *)yesterday;
- (NSDate *)today;
- (NSDate *)tomorrow;
- (NSDate *)theDayAfterTomorrow;
- (NSDate *)dateByAddingDayInterval:(NSInteger)interval;
- (NSString *)timestamp;
- (NSString *)timestampSimple;
- (NSInteger)thisYear;
- (NSInteger)thisMonth;
- (NSInteger)thisDay;
- (NSInteger)thisHour;
- (NSInteger)thisMinute;
- (NSInteger)thisSecond;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

- (NSString *)genderFromIDNumber:(NSString *)number;    //male results "M", female returns "F"
- (NSDate *)birthdayFromIDNumber:(NSString *)number;    //returns the date with format like "yyyyMMdd"

@end
