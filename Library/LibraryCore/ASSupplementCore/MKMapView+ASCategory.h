//
//  MKMapView+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-14.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ASCategory)

- (MKZoomScale)zoomScale;
//- (CGFloat)roadWidth;
- (MKCoordinateRegion)limitedRegion;
- (void)zoomToFitAnnotationsAnimated:(BOOL)animated;
- (void)zoomToFitAnnotationsAnimated:(BOOL)animated edgePadding:(UIEdgeInsets)insets;
- (void)removeAllAnnotations;
- (void)removeAllAnnotationsExceptUserLocation;
- (void)reloadAnnotations;
- (void)reloadAnnotationViewWithAnnotation:(id <MKAnnotation>)annotation;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated invalidCoordinateHandler:(void (^)(void))handler;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated invalidCoordinateHandler:(void (^)(void))handler;
- (void)addOverlay:(id <MKOverlay>)overlay ignoreDuplicate:(BOOL)ignore;
- (void)removeAllOverlays;

@end
