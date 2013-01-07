//
//  CalloutAnnotationView.m
//  PathMe
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Winfires. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CalloutAnnotationView.h"

@interface CalloutAnnotationView ()

@property (strong, nonatomic) UIView *calloutContentView;

- (void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;

@end

@implementation CalloutAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, - (size.height * .5 + 20 * .5 + kCalloutAnnotationViewArrowMargin));
        self.frame = CGRectMake(0, 0, size.width, size.height);
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kCalloutAnnotationViewArrowHeightDefault)];
        contentView.backgroundColor   = [UIColor clearColor];
        contentView.layer.cornerRadius = kCalloutAnnotationViewCornerRadius;
        [self addSubview:contentView];
        self.calloutContentView = contentView;
        [contentView release];
    }
    return self;
}

- (void)dealloc
{
    [_calloutContentView release];
    [super dealloc];
}

- (void)setCenterOffsetAccordingToAnnotationImageHeight:(CGFloat)height
{
    self.centerOffset = CGPointMake(10, - (self.frame.size.height * .5 + height * .5 + kCalloutAnnotationViewArrowMargin) - 22);
}

- (void)animateToPresent
{
    self.alpha = 1; // in case it's zero from fading out in -dismissCalloutAnimated
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    CAMediaTimingFunction *easeInOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    bounceAnimation.beginTime = CACurrentMediaTime();
    bounceAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.05],
                              [NSNumber numberWithFloat:1.11245],
                              [NSNumber numberWithFloat:0.951807],
                              [NSNumber numberWithFloat:1.0],nil];
    bounceAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:4.0/9.0],
                                [NSNumber numberWithFloat:4.0/9.0+5.0/18.0],
                                [NSNumber numberWithFloat:1.0],nil];
    bounceAnimation.duration = kCalloutAnnotationViewBounceAnimationDuration;
    bounceAnimation.timingFunctions = [NSArray arrayWithObjects:easeInOut, easeInOut, easeInOut, easeInOut,nil];
    bounceAnimation.delegate = self;
    
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
    //    CGContextSetLineWidth(context, 1.0);
    //     CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //    [self getDrawPath:context];
    //    CGContextStrokePath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = kCalloutAnnotationViewCornerRadius;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect) - kCalloutAnnotationViewArrowHeightDefault;
    CGContextMoveToPoint(context, midx + kCalloutAnnotationViewArrowHeightDefault, maxy);
    CGContextAddLineToPoint(context,midx, maxy + kCalloutAnnotationViewArrowHeightDefault);
    CGContextAddLineToPoint(context,midx - kCalloutAnnotationViewArrowHeightDefault, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

@end
