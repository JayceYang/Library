//
//  NSArray+Runtime.h
//  Library
//
//  Created by Jayce Yang on 13-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Runtime)

- (NSArray *)makeObjectsDictionaryValue;
- (NSArray *)makeObjectsClass:(Class)aClass;

@end
