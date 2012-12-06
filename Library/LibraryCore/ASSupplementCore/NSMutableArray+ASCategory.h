//
//  NSMutableArray+ASCategory.h
//  ASSupplement
//
//  Created by Yang Jayce on 12-4-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ASCategory)

- (void)sortUsingSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending;    // sorts the array itself

@end
