//
//  NSLocale+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 13-1-27.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import "NSLocale+ASCategory.h"

@implementation NSLocale (ASCategory)

- (NSString *)country
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    NSString *country = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
    return country;
}

@end
