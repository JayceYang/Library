//
//  NSObject+Runtime.m
//  Library
//
//  Created by Jayce Yang on 13-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Runtime.h"
#import "NSArray+Runtime.h"

static const char *GenericTypeKey = "genericTypeKey";

@implementation NSObject (Runtime)

- (NSDictionary *)dictionaryValue
{
    Class clazz = [self class];
    u_int count;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    Ivar* ivars = class_copyIvarList(clazz, &count);
    for (int i = 0; i < count ; i++)
    {
        // get variable's name and type
        const char* ivarCName = ivar_getName(ivars[i]);
        const char* ivarCType = ivar_getTypeEncoding(ivars[i]);
        
        // convert to NSString
        NSString *ivarName = [NSString stringWithCString:ivarCName encoding:NSUTF8StringEncoding];
        NSString *ivarType = [NSString stringWithCString:ivarCType encoding:NSUTF8StringEncoding];
        
        
//        NSLog(ivarName);
//        NSLog(ivarType);
//        NSLog(@"%@",[self valueForKey:ivarName]);
        
        id value = nil;
        //if ivarType equal to NSArray, convert it. 
        if ([ivarType compare:@"@\"NSArray\""] == NSOrderedSame)
            value = [(NSArray *)[self valueForKey:ivarName] makeObjectsDictionaryValue];
        
        //if ivarType equal to basic json object, nothing
        else if([ivarType compare:@"@\"NSString\""] == NSOrderedSame ||
           [ivarType compare:@"@\"NSNumber\""] == NSOrderedSame ||
           [ivarType compare:@"@\"NSDictionary\""] == NSOrderedSame)
        {
            value = [self valueForKey:ivarName]; 
        }
        
        // if ivarType equal to other object, convert to dictonary
        else
             value = [[self valueForKey:ivarName] dictionaryValue];
            
        
        // add to dictionary
        [dictionary setValue:value forKey:ivarName];
        
    }
    free(ivars);
    return [dictionary copy];
}

+ (void)setGenericType:(NSDictionary *)type
{
    objc_setAssociatedObject([self class], GenericTypeKey, type, OBJC_ASSOCIATION_COPY);
}

+ (NSDictionary *)genericType
{
    return (NSDictionary *)objc_getAssociatedObject([self class], GenericTypeKey);
}


@end
