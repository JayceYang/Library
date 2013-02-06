//
//  NSString+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-11.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ASCategory)

- (NSDate *)dateValueWithDateFormat:(NSString *)format;

- (BOOL)matchWithPattern:(NSString *)pattern;
- (BOOL)isValidNumber;
- (BOOL)isValidEmail;
- (BOOL)isValidMobile;
- (BOOL)isValidaCarPlate;

- (NSString *)gender;    //if the string is a valid ID string, male results "M", female returns "F"
- (NSDate *)birthday;    //if the string is a valid ID string, returns the date with format like "yyyyMMdd"
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

@end
