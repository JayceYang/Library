//
//  ASGeometry.m
//  Library
//
//  Created by Jayce Yang on 12-12-7.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "ASGeometry.h"

NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate)
{
    return [NSString stringWithFormat:@"latitude:%lf\tlongitude:%lf",coordinate.latitude,coordinate.longitude];
}

NSString *NSStringFromMKCoordinateSpan(MKCoordinateSpan span)
{
    return [NSString stringWithFormat:@"latitudeDelta:%lf\tlongitudeDelta:%lf",span.latitudeDelta,span.longitudeDelta];
}

NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region)
{
    return [NSString stringWithFormat:@"center:%@\nspan:%@",NSStringFromCLLocationCoordinate2D(region.center),NSStringFromMKCoordinateSpan(region.span)];
}

NSString *NSStringFromCGSize(CGSize size)
{
    return [NSString stringWithFormat:@"width:%lf\theight:%lf",size.width,size.height];
}