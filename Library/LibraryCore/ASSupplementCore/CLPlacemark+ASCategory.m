//
//  CLPlacemark+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import "CLPlacemark+ASCategory.h"

#import "NSObject+ASCategory.h"

@implementation CLPlacemark (ASCategory)

- (NSString *)formattedAddressLines
{
    NSString *addressLines = nil;
    id lines = [self.addressDictionary objectForKey:@"FormattedAddressLines"];
    if ([lines isKindOfClass:[NSArray class]]) {
        addressLines = [lines firstObject];
    } else {
        addressLines = [self stringValueFromValue:lines];
    }
    return addressLines;
}

@end
