//
//  CLGeocoder+ASCategory.h
//  Library
//
//  Created by Jayce Yang on 12-12-24.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (ASCategory)

+ (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(void (^)(CLPlacemark *placemark, NSError *error))completionHandler;
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(void (^)(CLPlacemark *placemark, NSError *error))completionHandler;

@end
