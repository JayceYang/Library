//
//  CLGeocoder+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 12-12-24.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "CLGeocoder+ASCategory.h"

#import "NSArray+ASCategory.h"

@implementation CLGeocoder (ASCategory)

+ (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(void (^)(CLPlacemark *placemark, NSError *error))completionHandler
{
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        completionHandler([placemarks firstObject],error);
    }];
}

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(void (^)(CLPlacemark *placemark, NSError *error))completionHandler
{
    [self reverseGeocodeLocation:[[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] autorelease] completionHandler:completionHandler];
}

@end
