//
//  CLGeocoder+ASCategory.h
//  Library
//
//  Created by Jayce Yang on 12-12-24.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (ASCategory)

+ (void)reverseGeocodeLocation:(CLLocation *)location addressCompletionHandler:(void (^)(NSString *address, NSError *error))completionHandler;
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate addressCompletionHandler:(void (^)(NSString *address, NSError *error))completionHandler;

+ (void)reverseGeocodeLocation:(CLLocation *)location countryCompletionHandler:(void (^)(NSString *country, NSError *error))completionHandler;
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate countryCompletionHandler:(void (^)(NSString *country, NSError *error))completionHandler;

+ (void)reverseGeocodeLocation:(CLLocation *)location administrativeAreaCompletionHandler:(void (^)(NSString *administrativeArea, NSError *error))completionHandler;
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate administrativeAreaCompletionHandler:(void (^)(NSString *administrativeArea, NSError *error))completionHandler;

+ (void)reverseGeocodeLocation:(CLLocation *)location localityCompletionHandler:(void (^)(NSString *locality, NSError *error))completionHandler;
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate localityCompletionHandler:(void (^)(NSString *locality, NSError *error))completionHandler;

+ (void)reverseGeocodeLocation:(CLLocation *)location areaCompletionHandler:(void (^)(NSString *area, NSError *error))completionHandler;
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate areaCompletionHandler:(void (^)(NSString *area, NSError *error))completionHandler;

@end
