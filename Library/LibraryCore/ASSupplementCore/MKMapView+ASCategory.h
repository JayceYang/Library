//
//  MKMapView+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-14.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ASCategory)

- (MKCoordinateRegion)limitedRegion;
- (void)zoomToFitAnnotations;
- (void)zoomToFitAnnotationsWithSideSpacingFactor:(CGFloat)factor;
- (void)removeAllAnnotations;
- (void)reloadAnnotations;
- (void)reloadAnnotationViewWithAnnotation:(id <MKAnnotation>)annotation;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated invalidCoordinateHandler:(void (^)(void))handler;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated invalidCoordinateHandler:(void (^)(void))handler;
- (void)addOverlay:(id <MKOverlay>)overlay ignoreDuplicate:(BOOL)ignore;

@end
