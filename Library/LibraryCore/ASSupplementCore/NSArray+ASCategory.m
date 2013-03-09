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

- (id)objectAtTheIndex:(NSInteger)index
{
    if (![self isKindOfClass:[NSArray class]]) {
        ASLog(@"%@ is not array type", NSStringFromClass([self class]));
        return nil;
    } else if (index >= self.count) {
        ASLog(@"index (%d) beyond bounds (%d)", index, self.count);
        return nil;
    }  else if (index < 0) {
        ASLog(@"index (%d) is invalid", index);
        return nil;
    } else {
        return [self objectAtIndex:index];
    }
}

- (id)firstObject
{
    return [self objectAtTheIndex:0];
}

- (id)theLastObject
{
    return [self objectAtTheIndex:self.count - 1];
}

@end
