//
//  CLLocation+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import "CLLocation+ASCategory.h"

@implementation CLLocation (ASCategory)

- (NSString *)latitude
{
    if (self) {
        return [NSString stringWithFormat:@"%lf",self.coordinate.latitude];
    } else {
        return [NSString string];
    }
}

- (NSString *)longitude
{
    if (self) {
        return [NSString stringWithFormat:@"%lf",self.coordinate.longitude];
    } else {
        return [NSString string];
    }
}

@end
