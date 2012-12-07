//
//  NSDate+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 12-12-7.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSDate+ASCategory.h"

@implementation NSDate (ASCategory)

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

- (NSString *)timestamp
{
    return [NSString string];
//    NSString *retVal = nil;
//    // Calculate distance time string
//    //
//    time_t now;
//    time(&now);
//    
//    int distance = (int)difftime(now, [self timeIntervalSince1970]);
//    
//    //    ASLog(@"distance:%d,now:%qi,%qi",distance,now,[dt timeIntervalSince1970]);
//    NSDate *today = [NSDate dateFromString:[[NSDate date] stringWithFormat:@"yyyy-MM-dd 00:00:00"]];
//    NSDate *yesterday = [NSDate dateFromString:[[[NSDate date] dateAfterDay:-1] stringWithFormat:@"yyyy-MM-dd  00:00:00"]];
//    NSDate *before = [NSDate dateFromString:[[[NSDate date] dateAfterDay:-2] stringWithFormat:@"yyyy-MM-dd  00:00:00"]];
//    NSDate *thisYear = [NSDate dateFromString:[[NSDate date] stringWithFormat:@"yyyy-01-01  00:00:00"]];
//    
//    if (distance < 0) distance = 0;
//    //    ASLog(@"ff:%.2f,%.2f,%.2f,%.2f",[self timeIntervalSinceDate:today],[self timeIntervalSinceDate:yesterday],[self timeIntervalSinceDate:before],[self timeIntervalSinceDate:thisYear]);
//    if ([self timeIntervalSinceDate:today] >= 0) {
//        if (distance < 60) {
//            retVal = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
//        }else if (distance < 60 * 60) {
//            distance = distance / 60;
//            retVal = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
//        }else if (distance < 60 * 60 * 24) {
//            distance = distance / 60 / 60;
//            retVal = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
//        }
//    }else if ([self timeIntervalSinceDate:yesterday] >= 0){
//        //        retVal = @"昨天";
//        retVal = [NSString stringWithFormat:@"昨天 %@",[NSDate stringFromDate:self withFormat:@"HH:mm"]];
//    }else if ([self timeIntervalSinceDate:before] >= 0){
//        retVal = [NSString stringWithFormat:@"前天 %@",[NSDate stringFromDate:self withFormat:@"HH:mm"]];
//    }else if ([self timeIntervalSinceDate:thisYear] >= 0){
//        retVal = [NSDate stringFromDate:self withFormat:@"MM月dd日 HH:mm"];
//    }else {
//        retVal = [NSDate stringFromDate:self withFormat:@"yyyy-MM-dd HH:mm"];
//    }
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

@end
