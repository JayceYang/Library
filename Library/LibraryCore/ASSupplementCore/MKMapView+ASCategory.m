//
//  MKMapView+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-14.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "MKMapView+ASCategory.h"
#import "NSObject+ASCategory.h"
#import "ASGeometry.h"

static CLLocationDegrees const kMinimumLatitude = - 90;
static CLLocationDegrees const kMaximumLatitude = 90;
static CLLocationDegrees const kMinimumLongitude = - 180;
static CLLocationDegrees const kMaximumLongitude = 180;

@implementation MKMapView (ASCategory)

#pragma mark - Public

- (MKZoomScale)zoomScale
{
    return self.visibleMapRect.size.width / self.bounds.size.width;
}

- (CGFloat)roadWidth
{
    return MKRoadWidthAtZoomScale([self zoomScale]);
}

- (MKCoordinateRegion)limitedRegion
{
    // this call is broken on iOS 5, as is the region property, so don't use them
    // return( [self convertRect:self.bounds toRegionFromView:self] );
    
    CLLocationCoordinate2D topLeft = [self convertPoint:CGPointZero toCoordinateFromView:self];
    CLLocationCoordinate2D bottomRight = [self convertPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height) toCoordinateFromView:self];
    
    MKCoordinateRegion region;
    region.center.latitude = (topLeft.latitude + bottomRight.latitude)/2;
    region.center.longitude = (topLeft.longitude + bottomRight.longitude)/2;
    region.span.latitudeDelta = fabs(topLeft.latitude - bottomRight.latitude );
    region.span.longitudeDelta = fabs(topLeft.longitude - bottomRight.longitude );
    return region;
}
- (void)zoomToFitAnnotationsAnimated:(BOOL)animated
{
    [self zoomToFitAnnotationsAnimated:animated edgePadding:UIEdgeInsetsZero];
}

- (void)zoomToFitAnnotationsAnimated:(BOOL)animated edgePadding:(UIEdgeInsets)insets
{
    if ([self.annotations count] == 0) {
        return;
    }
    
    MKMapRect mapRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.annotations) {
        MKMapPoint mapPoint = MKMapPointForCoordinate([annotation coordinate]);
        mapRect = MKMapRectUnion(mapRect, MKMapRectMake(mapPoint.x, mapPoint.y, 0, 0));
    }
    
    mapRect = [self mapRectThatFits:mapRect edgePadding:insets];
    [self setVisibleMapRect:mapRect edgePadding:insets animated:YES];
    
//    CLLocationCoordinate2D topLeftCoord;
//    topLeftCoord.latitude = kMinimumLatitude;
//    topLeftCoord.longitude = kMaximumLongitude;
//    
//    CLLocationCoordinate2D bottomRightCoord;
//    bottomRightCoord.latitude = kMaximumLatitude;
//    bottomRightCoord.longitude = kMinimumLongitude;
//    
//    for (id<MKAnnotation> annotation in self.annotations) {
//        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
//        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
//        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
//        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
//    }
//    
//    MKCoordinateRegion region;
//    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
//    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
//    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * factor;
//    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * factor;
//    
//    region = [self regionThatFits:region];
//    [self setRegion:region animated:YES];
}

- (void)removeAllAnnotations
{
    [self removeAnnotations:self.annotations];
}

- (void)reloadAnnotations
{
    NSArray *annotations = [self.annotations copy];
    [self removeAnnotations:annotations];
    [self addAnnotations:annotations];
    [annotations release];
}

- (void)reloadAnnotationViewWithAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation) {
        [self removeAnnotation:annotation];
        [self addAnnotation:annotation];
    }
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated invalidCoordinateHandler:(void (^)(void))handler
{
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        ASLog(@"Invalid coordinate:%@",NSStringFromCLLocationCoordinate2D(coordinate));
        if (handler) {
            handler();
        }
    } else {
        [self setCenterCoordinate:coordinate animated:animated];
    }
}

- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated invalidCoordinateHandler:(void (^)(void))handler
{
    if (CLLocationCoordinate2DIsValid(region.center)) {
        ASLog(@"Invalid coordinate:%@",NSStringFromCLLocationCoordinate2D(region.center));
        if (handler) {
            handler();
        }
    } else {
        MKCoordinateRegion fitRegion = [self regionThatFits:region];
        if (isnan(fitRegion.center.latitude)) {
            // iOS 6 will result in nan.
            fitRegion.center.latitude = region.center.latitude;
            fitRegion.center.longitude = region.center.longitude;
            fitRegion.span.latitudeDelta = 0;
            fitRegion.span.longitudeDelta = 0;
        }
        [self setRegion:fitRegion animated:animated];
    }
}

- (void)addOverlay:(id <MKOverlay>)overlay ignoreDuplicate:(BOOL)ignore
{
    if (ignore) {
        BOOL duplicate = NO;
        for (id existsOverlay in self.overlays) {
            if (doubleEqualToDouble(overlay.coordinate.latitude, ((id <MKOverlay>)existsOverlay).coordinate.latitude) && doubleEqualToDouble(overlay.coordinate.longitude, ((id <MKOverlay>)existsOverlay).coordinate.longitude)) {
                duplicate = YES;
                break;
            }
        }
        if (!duplicate) {
            [self addOverlay:overlay];
        }
    } else {
        [self addOverlay:overlay];
    }
}

- (void)removeAllOverlays
{
    [self removeOverlays:self.overlays];
}

@end
