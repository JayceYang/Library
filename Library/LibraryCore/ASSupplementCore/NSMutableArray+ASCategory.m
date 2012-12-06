//
//  NSMutableArray+ASCategory.m
//  ASSupplement
//
//  Created by Yang Jayce on 12-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSMutableArray+ASCategory.h"

@implementation NSMutableArray (ASCategory)

- (void)sortUsingSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [self sortUsingDescriptors:sortDescriptors];
}

@end
