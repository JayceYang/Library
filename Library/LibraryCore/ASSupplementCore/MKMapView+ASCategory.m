//
//  MKMapView+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-14.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "MKMapView+ASCategory.h"
#import "NSObject+ASCategory.h"

@implementation MKMapView (ASCategory)

#pragma mark - Public

- (void)zoomToFitAnnotations
{
    [self zoomToFitAnnotationsWithSideSpacingFactor:1.0];
}

- (void)zoomToFitAnnotationsWithSideSpacingFactor:(CGFloat)factor
{
    if ([self.annotations count] == 0) {
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = - 90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = - 180;
    
    for (id<MKAnnotation> annotation in self.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * factor;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * factor;
    
    region = [self regionThatFits:region];
    [self setRegion:region animated:YES];
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

- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated outOfBoundsBlock:(void (^)(void))block
{
    if (fabs(region.center.latitude) > 90 || fabs(region.center.longitude) > 180 || fabs(region.span.latitudeDelta) > 180 || fabs(region.span.longitudeDelta) > 180) {
        if (block) {
            block();
        }
    } else {
        [self setRegion:region animated:animated];
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

@end
