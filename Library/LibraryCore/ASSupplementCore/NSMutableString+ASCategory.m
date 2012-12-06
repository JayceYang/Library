//
//  NSMutableString+ASCategory.m
//  ASSupplement
//
//  Created by Yang Jayce on 12-6-11.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSMutableString+ASCategory.h"

@implementation NSMutableString (ASCategory)

- (void)appendTreeStyleString:(NSString *)string 
{
    NSArray *appendedStrings = [string componentsSeparatedByString:@"/"];
    for (NSString *appendedString in appendedStrings) {
        [self appendString:appendedString];
    }
}

@end
