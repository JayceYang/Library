//
//  CLLocation+ASCategory.h
//  Library
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (ASCategory)

@property (copy, nonatomic) CLPlacemark *placemark;

- (NSString *)latitude;
- (NSString *)longitude;

@end
