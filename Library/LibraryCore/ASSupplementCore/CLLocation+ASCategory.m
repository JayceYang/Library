//
//  CLLocation+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import <objc/runtime.h>

#import "CLLocation+ASCategory.h"
#import "CLGeocoder+ASCategory.h"

static char CLLocationCLPlacemarkKey;

@implementation CLLocation (ASCategory)

- (CLPlacemark *)placemark
{
    CLPlacemark *placemark = objc_getAssociatedObject(self, &CLLocationCLPlacemarkKey);
    if (!placemark) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [CLGeocoder reverseGeocodeLocation:self completionHandler:^(CLPlacemark *placemark, NSError *error) {
                self.placemark = placemark;
            }];
        });
    }
    return placemark;
}

- (void)setPlacemark:(CLPlacemark *)placemark
{
    [self willChangeValueForKey:@"placemark"];
    objc_setAssociatedObject(self, &CLLocationCLPlacemarkKey, placemark, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"placemark"];
}

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