//
//  NSDictionary+Runtime.m
//  Library
//
//  Created by Jayce Yang on 13-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <objc/runtime.h>

#import "NSDictionary+Runtime.h"
#import "NSObject+Runtime.h"
#import "NSArray+Runtime.h"

@implementation NSDictionary (Runtime)

- (id)valueOfClass:(Class)aClass
{
    id object = [[aClass alloc] init];
    
    u_int count;
    Ivar* ivars = class_copyIvarList(aClass, &count);
    for (int i = 0; i < count ; i++)
    {
        // get variable's name and type
        const char* ivarCName = ivar_getName(ivars[i]);
        const char* ivarCType = ivar_getTypeEncoding(ivars[i]);
        
        // convert to NSString
        NSString *ivarName = [NSString stringWithCString:ivarCName encoding:NSUTF8StringEncoding];
        NSString *ivarType = [NSString stringWithCString:ivarCType encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:ivarName];
        if ([value isKindOfClass:[NSString class]] ||
           [value isKindOfClass:[NSNumber class]] ||
           value == nil);
            // do nothing converting.
        else if([value isKindOfClass:[NSNull class]])
            value = nil;
        else if([value isKindOfClass:[NSArray class]] )
        {
            Class genericClass = [[aClass genericType] valueForKey:ivarName];
            value = [(NSArray *)value makeObjectsClass:genericClass];
        }
            
        else if([value isKindOfClass:[NSDictionary class]] )
        {
            // convert to NSDictionary
            value = (NSDictionary *)value;
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            value = [value valueOfClass: NSClassFromString(ivarType)];
        }
        else
            NSLog(@"[NSDictionary+JSON] unknown type: %@",NSStringFromClass([value class]));
        
        // set the value into object
        [object setValue:value forKey:ivarName];

    }
    free(ivars);
    return [object autorelease];
        
}
    
@end
