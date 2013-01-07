//
//  CalloutAnnotationView.h
//  PathMe
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Winfires. All rights reserved.
//

#import <MapKit/MapKit.h>

#define     kCalloutAnnotationViewCornerRadius       6
#define     kCalloutAnnotationViewArrowHeightDefault 15
#define     kCalloutAnnotationViewArrowMargin        4
#define     kCalloutAnnotationViewBounceAnimationDuration (1.0/3.0)

@interface CalloutAnnotationView : MKAnnotationView

@property (readonly, strong, nonatomic) UIView *calloutContentView;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size;

- (void)setCenterOffsetAccordingToAnnotationImageHeight:(CGFloat)height;
- (void)animateToPresent;

@end
