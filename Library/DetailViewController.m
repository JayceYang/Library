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

@interface DetailViewController ()
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    

//    CGFloat width = 100;
    CGFloat height = 30;
    self.detailDescriptionLabel = [self.view labelWithFrame:CGRectInset([self mainBounds], 0, (CGRectGetHeight([self mainBounds]) - height) * .5) text:nil textColor:[UIColor redColor] textAlignment:UITextAlignmentCenter font:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    [self.view addSubview:_detailDescriptionLabel];
    
    [self configureView];
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

@end
