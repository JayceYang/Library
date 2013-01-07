//
//  CalloutAnnotation.m
//  PathMe
//
//  Created by Jayce Yang on 13-1-1.
//  Copyright (c) 2013年 Winfires. All rights reserved.
//

#import "CalloutAnnotation.h"

@interface CalloutAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation CalloutAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.coordinate = coordinate;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
