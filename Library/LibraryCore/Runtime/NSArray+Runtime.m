//
//  NSArray+Runtime.m
//  Library
//
//  Created by Jayce Yang on 13-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <objc/runtime.h>

#import "NSArray+Runtime.h"
#import "NSObject+Runtime.h"
#import "NSDictionary+Runtime.h"


@implementation NSArray (Runtime)

/*
 convert array of object to array of dictionary
 */
- (NSArray *)makeObjectsDictionaryValue
{
    NSInteger count = [self count];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for(int i = 0; i < count; ++i)
    {
        id obj = [self objectAtIndex:i];
        // if obj is NSString,NSNumber, do nothing convert
        if([obj isKindOfClass:[NSString class]] ||
           [obj isKindOfClass:[NSNumber class]])
            [mutableArray addObject:obj];
        
        // if other obj, convert to dictionary
        else
            [mutableArray addObject:[obj dictionaryValue]];
    }
    return [[mutableArray copy] autorelease];

}

/*
 Convert array of dictionary to array of object(include customize object)
 */
- (NSArray *)makeObjectsClass:(Class)aClass
{
    NSInteger count = [self count];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for(int i = 0; i < count; ++i)
    {
        id obj = [self objectAtIndex:i];
        if([obj isKindOfClass:[NSString class]] ||
           [obj isKindOfClass:[NSNumber class]]);
        // do nothing converting.
        else 
        {
            if(aClass != nil)
                obj = [(NSDictionary *)obj valueOfClass:aClass];
        }
        
        [mutableArray addObject:obj];
        
    }
    return [[mutableArray copy] autorelease];
}

@end
