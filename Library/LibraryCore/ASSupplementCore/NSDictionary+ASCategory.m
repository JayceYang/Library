//
//  NSDictionary+ASCategory.m
//  ASSupplement
//
//  Created by Yang Jayce on 12-4-17.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "NSDictionary+ASCategory.h"

@implementation NSDictionary (ASCategory)

- (id)objectForTreeStyleKey:(NSString*)key 
{
	NSArray *keys = [key componentsSeparatedByString:@"/"];
	NSDictionary *dictionary = [[self copy] autorelease];
    NSInteger count = [keys count];
	for (NSInteger n = 0; n < count - 1; n ++) {
		dictionary = [dictionary objectForKey:[keys objectAtIndex:n]];
	}
	return [dictionary objectForKey:[keys objectAtIndex:count - 1]];
}

@end
