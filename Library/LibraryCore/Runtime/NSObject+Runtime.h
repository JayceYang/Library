//
//  NSObject+Runtime.h
//  Library
//
//  Created by Jayce Yang on 13-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

- (NSDictionary *)dictionaryValue;
+ (void)setGenericType:(NSDictionary *)type;
+ (NSDictionary *)genericType;

@end
