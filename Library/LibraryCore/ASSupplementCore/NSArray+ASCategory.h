//
//  NSArray+ASCategory.h
//  ASSupplement
//
//  Created by Yang Jayce on 12-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ASCategory)

// returns a new array by sorting the objects of the receiver
- (NSArray *)sortedArrayUsingDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending;
- (id)objectAtTheIndex:(NSInteger)index;
- (id)firstObject;
- (id)theLastObject;

@end
