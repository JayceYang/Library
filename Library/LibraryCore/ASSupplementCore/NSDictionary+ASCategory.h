//
//  NSDictionary+ASCategory.h
//  ASSupplement
//
//  Created by Yang Jayce on 12-4-17.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ASCategory)

- (id)objectForTreeStyleKey:(NSString*)key;     //format the key to string separated by "/", eg. key/subkey

@end
