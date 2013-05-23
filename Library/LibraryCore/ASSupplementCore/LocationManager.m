//
//  LocationManager.m
//  Library
//
//  Created by Jayce Yang on 12-12-28.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "LocationManager.h"

#import "NSArray+ASCategory.h"

@interface LocationManager () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (copy, nonatomic) void (^successHandler)(CLLocation *location);
@property (copy, nonatomic) void (^failureHandler)(NSError *error);

@end

@implementation LocationManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        self.corrective = YES;
        self.stopUpdatingWhenSuccess = YES;
    }
    return self;
}

- (void)dealloc
{
    [_locationManager release];
    [_mapView release];
    [_successHandler release];
    [_failureHandler release];
    [super dealloc];
}

+ (LocationManager *)sharedManager
{
    static LocationManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)startUpdatingLocationWithSuccessHandler:(void (^)(CLLocation *location))successHandler
{
    [self startUpdatingLocationWithSuccessHandler:successHandler failureHandler:NULL];
}

- (void)startUpdatingLocationWithSuccessHandler:(void (^)(CLLocation *location))successHandler failureHandler:(void (^)(NSError *error))failureHandler
{
    self.successHandler = successHandler;
    self.failureHandler = failureHandler;
    
    if (_corrective) {
        self.mapView = [[[MKMapView alloc] init] autorelease];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
    } else {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation
{
    if (_corrective) {
        _mapView.delegate = nil;
        _mapView.showsUserLocation = NO;
        [_mapView release];
        _mapView = nil;
    } else {
        _locationManager.delegate = nil;
        [_locationManager stopUpdatingLocation];
        [_locationManager release];
        _locationManager = nil;
    }
}

#pragma mark - CLLocationManagerDelegate

/* For iOS 6 and above. */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_successHandler) {
        _successHandler([locations theFirstObject]);
        if (_stopUpdatingWhenSuccess) {
            [self stopUpdatingLocation];
        }
    }
}

/* For iOS 6 below */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (_successHandler) {
        _successHandler(newLocation);
        if (_stopUpdatingWhenSuccess) {
            [self stopUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_failureHandler) {
        _failureHandler(error);
        if (_stopUpdatingWhenSuccess) {
            [self stopUpdatingLocation];
        }
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_successHandler) {
        _successHandler([userLocation location]);
        if (_stopUpdatingWhenSuccess) {
            [self stopUpdatingLocation];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if (_failureHandler) {
        _failureHandler(error);
        if (_stopUpdatingWhenSuccess) {
            [self stopUpdatingLocation];
        }
    }
}

@end
