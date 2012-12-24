//
//  CLGeocoder+ASCategory.m
//  Library
//
//  Created by Jayce Yang on 12-12-24.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "CLGeocoder+ASCategory.h"

#import "NSArray+ASCategory.h"
#import "NSObject+ASCategory.h"

@implementation CLGeocoder (ASCategory)

+ (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(void (^)(NSString *address, NSError *error))completionHandler
{
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString *address = nil;
        CLPlacemark *placemark = [placemarks firstObject];
        id formattedAddressLines = [placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
        if ([formattedAddressLines isKindOfClass:[NSArray class]]) {
            address = [formattedAddressLines firstObject];
        } else {
            address = [placemark stringValueFromValue:formattedAddressLines];
        }
        completionHandler(address, nil);
    }];
}

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(void (^)(NSString *address, NSError *error))completionHandler
{
    [self reverseGeocodeLocation:[[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] autorelease] completionHandler:completionHandler];
}

@end
