//
//  NSDate+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 12-12-7.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSDate+ASCategory.h"
#import "NSObject+ASCategory.h"
#import "NSString+ASCategory.h"

@implementation NSDate (ASCategory)

- (NSDate *)theDayBeforeYesterday
{
    return [self dateByAddingDayIntervalSinceNow:-2];
}

- (NSDate *)yesterday
{
    return [self dateByAddingDayIntervalSinceNow:-1];
}

- (NSDate *)today
{
    return [self dateByAddingDayIntervalSinceNow:0];
}

- (NSDate *)tomorrow
{
    return [self dateByAddingDayIntervalSinceNow:1];
}

- (NSDate *)theDayAfterTomorrow
{
    return [self dateByAddingDayIntervalSinceNow:2];
}

- (NSDate *)midnight
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSDate *date = [calendar dateFromComponents:dateComponents];
//    ASLog(@"%@",[date stringValueWithDateFormat:kDateFormatHorizontalLineLong]);
    return date;
}

- (NSDate *)midday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [dateComponents setHour:12];
	NSDate *date = [calendar dateFromComponents:dateComponents];
//    ASLog(@"%@",[date stringValueWithDateFormat:kDateFormatHorizontalLineLong]);
    return date;
}

//- (NSDate *)dateWithDayInterval:(NSInteger)dayInterval sinceDate:(NSDate *)sinceDate
//{
//    NSTimeInterval timeInterval = 60 * 60 * 24 * dayInterval;
//    return [NSDate dateWithTimeInterval:timeInterval sinceDate:sinceDate];
//}

- (NSDate *)dateByAddingDayInterval:(NSInteger)interval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:interval];
    NSDate *date = [calendar dateByAddingComponents:componentsToSubtract toDate:midnight options:0];
    [componentsToSubtract release];
    return date;
}

- (NSDate *)dateByAddingDayIntervalSinceNow:(NSInteger)interval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:interval];
    NSDate *date = [calendar dateByAddingComponents:componentsToSubtract toDate:midnight options:0];
    [componentsToSubtract release];
    return date;
}

- (NSString *)stringValueWithDateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:self];
}

- (NSString *)timestamp
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	NSString *displayString = nil;
	
    // comparing against midnight
    NSComparisonResult comparisonResult = [self compare:midnight];
    if (comparisonResult == NSOrderedSame) {
        NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
        [displayFormatter setDateFormat:@"HH:mm"];
        displayString = [displayFormatter stringFromDate:self];
        [displayFormatter release];
    } else if (comparisonResult == NSOrderedDescending) {
		NSTimeInterval timeInterval = [today timeIntervalSinceDate:self];
        NSInteger timeIntervalInteger = 0;
        if (timeInterval < 60) {
            timeIntervalInteger = (NSInteger)ceil(timeInterval);
            displayString = [NSString stringWithFormat:@"%d %@", timeIntervalInteger, timeIntervalInteger > 1 ? NSLocalizedString(@"seconds before", nil) : NSLocalizedString(@"second before", nil)];
        } else if (timeInterval < 60 * 60) {
            timeInterval = timeInterval / 60;
            timeIntervalInteger = (NSInteger)floor(timeInterval);
            displayString = [NSString stringWithFormat:@"%d %@", timeIntervalInteger, timeIntervalInteger > 1 ? NSLocalizedString(@"minutes before", nil) : NSLocalizedString(@"minute before", nil)];
        } else if (timeInterval < 60 * 60 * 24) {
            timeInterval = timeInterval / 60 / 60;
            timeIntervalInteger = (NSInteger)floor(timeInterval);
            displayString = [NSString stringWithFormat:@"%d %@", timeIntervalInteger, timeIntervalInteger > 1 ? NSLocalizedString(@"hours before", nil) : NSLocalizedString(@"hour before", nil)];
        }
	} else {
        NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
        
        // check if date is within last 2 days
		NSDate *theDayBeforeYesterday = [self theDayBeforeYesterday];
        NSDate *yesterday = [self yesterday];
        NSComparisonResult theDayBeforeYesterdayComparisonResult = [self compare:theDayBeforeYesterday];
        NSComparisonResult yesterdayComparisonResult = [self compare:yesterday];
		if (theDayBeforeYesterdayComparisonResult != NSOrderedAscending) {
            [displayFormatter setDateFormat:@"HH:mm"];
            if (yesterdayComparisonResult != NSOrderedAscending) {
                displayString = [NSString stringWithFormat:@"%@ ", NSLocalizedString(@"yesterday", nil)];
            } else {
                displayString = [NSString stringWithFormat:@"%@ ", NSLocalizedString(@"the day before yesterday", nil)];
            }
            displayString = [displayString stringByAppendingString:[displayFormatter stringFromDate:self]];
		} else {
            // check if date is within last 7(> 2) days
            NSDate *lastWeek = [self dateByAddingDayIntervalSinceNow:-7];
            NSComparisonResult lastWeekComparisonResult = [self compare:lastWeek];
            if (lastWeekComparisonResult != NSOrderedAscending) {
                NSTimeInterval timeInterval = [today timeIntervalSinceDate:self];
                NSInteger dayIntervalInteger = (NSInteger)floor(timeInterval / (60 * 60 * 24));
                displayString = [NSString stringWithFormat:@"%d %@ ", dayIntervalInteger, dayIntervalInteger > 1 ? NSLocalizedString(@"days ago", nil) : NSLocalizedString(@"day ago", nil)];
                [displayFormatter setDateFormat:@"HH:mm"];
                displayString = [displayString stringByAppendingString:[displayFormatter stringFromDate:self]];
            } else {
                // check if same calendar year
                NSInteger thisYear = [offsetComponents year];
                NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
                NSInteger thatYear = [dateComponents year];
                if (thatYear >= thisYear) {
                    [displayFormatter setDateFormat:@"MMMdd HH:mm"];
                } else {
                    //                    [displayFormatter setDateStyle:NSDateFormatterMediumStyle];
                    //                    [displayFormatter setTimeStyle:NSDateFormatterMediumStyle];
                    [displayFormatter setDateFormat:@"MMMdd yyyy HH:mm"];
                }
                displayString = [displayFormatter stringFromDate:self];
            }
		}
        [displayFormatter release];
    }
    //    ASLog(@"%@",displayString);
	return displayString;
}

- (NSString *)timestampSimple
{
    /*
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	NSString *displayString = nil;
	
	// comparing against midnight
    NSComparisonResult comparisonResult = [self compare:midnight];
	if (comparisonResult == NSOrderedDescending) {
		[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		[componentsToSubtract release];
        NSComparisonResult lastweekComparisonResult = [self compare:lastweek];
		if (lastweekComparisonResult == NSOrderedDescending) {
            [displayFormatter setDateFormat:@"EEEE h:mm a"];
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
			NSInteger thatYear = [dateComponents year];
			if (thatYear >= thisYear) {
                [displayFormatter setDateFormat:@"MMM d h:mm a"];
			} else {
                [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
			}
		}
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:self];
    
    [displayFormatter release];
    
	return displayString;
}

- (NSInteger)thisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    return [dateComponents year];
}

- (NSInteger)thisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    return [dateComponents month];
}

- (NSInteger)thisDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:[NSDate date]];
    return [dateComponents day];
}

- (NSInteger)thisHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:[NSDate date]];
    return [dateComponents hour];
}

- (NSInteger)thisMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:[NSDate date]];
    return [dateComponents minute];
}

- (NSInteger)thisSecond
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSSecondCalendarUnit fromDate:[NSDate date]];
    return [dateComponents second];
}

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:self];
    return [dateComponents minute];
}

- (NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSSecondCalendarUnit fromDate:self];
    return [dateComponents second];
}

@end
