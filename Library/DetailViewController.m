//
//  DetailViewController.m
//  ASSupplementDemo
//
//  Created by Jayce Yang on 12-12-6.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "DetailViewController.h"

#import "ASSupplement.h"

@interface DetailViewController () <MKMapViewDelegate>
@property (strong, nonatomic) UILabel *detailDescriptionLabel;
- (void)configureView;
@end

@implementation DetailViewController

- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)loadView
{
    [super loadView];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MKMapView *mapView = [self.view.subviews lastObject];
////    ASLog(@"%@",NSStringFromMKCoordinateRegion(mapView.limitedRegion));
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(22.5, 113.9), MKCoordinateSpanMake(-119, 179.999999));
    [mapView setRegion:region animated:YES invalidCoordinateHandler:^{
        ;
    }];
//    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(22.5, 1133.9) animated:YES outOfBoundsBlock:^{
//        ASLog(@"xxx");
//    }];
//    CGFloat width = 100;
//    CGFloat height = 30;
//    self.detailDescriptionLabel = [self.view labelWithFrame:CGRectInset([self mainBounds], 0, (CGRectGetHeight([self mainBounds]) - height) * .5) text:nil textColor:[UIColor redColor] textAlignment:UITextAlignmentCenter font:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
//    [self.view addSubview:_detailDescriptionLabel];
//    
//    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"\n1:%@",NSStringFromMKCoordinateRegion(mapView.limitedRegion));
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"\n2:%@",NSStringFromMKCoordinateRegion(mapView.limitedRegion));
}

@end
