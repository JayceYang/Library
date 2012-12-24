//
//  MKMapView+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-14.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ASCategory)

- (void)zoomToFitAnnotations;
- (void)zoomToFitAnnotationsWithSideSpacingFactor:(CGFloat)factor;
- (void)removeAllAnnotations;
- (void)reloadAnnotations;
- (void)reloadAnnotationViewWithAnnotation:(id <MKAnnotation>)annotation;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated outOfBoundsBlock:(void (^)(void))block;
- (void)addOverlay:(id <MKOverlay>)overlay ignoreDuplicate:(BOOL)ignore;

@end
