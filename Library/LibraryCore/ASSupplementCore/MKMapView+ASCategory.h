//
//  MKMapView+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-8-14.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ASCategory)

//- (void)setZoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;
- (void)removeAllAnnotations;
- (void)reloadData;
- (void)reloadAnnotationViewWithAnnotation:(id <MKAnnotation>)annotation;
- (void)setVerificationRegion:(MKCoordinateRegion)region animated:(BOOL)animated;
- (void)addOverlay:(id <MKOverlay>)overlay ignoreDuplicate:(BOOL)ignore;
@end
