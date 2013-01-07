//
//  CalloutAnnotation.h
//  PathMe
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Winfires. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CalloutAnnotation : NSObject <MKAnnotation>

@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
