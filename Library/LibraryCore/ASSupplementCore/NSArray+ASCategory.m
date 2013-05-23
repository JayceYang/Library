//
//  NSArray+ASCategory.m
//  ASSupplement
//
//  Created by Yang Jayce on 12-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSArray+ASCategory.h"
#import "NSObject+ASCategory.h"

@implementation NSArray (ASCategory)

- (NSArray *)sortedArrayUsingDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self sortedArrayUsingDescriptors:sortDescriptors];
}

- (id)objectAtTheIndex:(NSUInteger)index
{
    id result = nil;
    @try {
        result = [self objectAtIndex:index];
    }
    @catch (NSException *exception) {
        ASLog(@"%@",exception.reason);
    }
    @finally {
        return result;
    }
}

- (id)theFirstObject
{
    return [self objectAtTheIndex:0];
}

- (id)theLastObject
{
    return [self objectAtTheIndex:self.count - 1];
}

@end
