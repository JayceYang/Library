//
//  LoadingView.m
//  PhoneOnline
//
//  Created by Jayce Yang on 12-9-22.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "LoadingView.h"
#import "UIViewController+ASCategory.h"
#import "NSObject+ASCategory.h"

#define kLoadingViewAnimateDuration 0.2f

@interface LoadingView ()

- (void)adjustSubviews;

@end

@implementation LoadingView

@synthesize tipsLabel = _tipsLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kContentViewWidth, kContentViewHeigth)];
        [self addSubview:_contentView];
        
        UIView *dimView = [[UIView alloc] initWithFrame:_contentView.bounds];
        dimView.backgroundColor = [UIColor blackColor];
        dimView.alpha = .8;
        dimView.layer.cornerRadius = 10;
        dimView.layer.masksToBounds = YES;
        [_contentView addSubview:dimView];
        [dimView release];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicatorView.center = CGPointMake(kContentViewWidth * .5, kContentViewHeigth * .5 - 10);
        [_contentView addSubview:_activityIndicatorView];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_activityIndicatorView.frame), kContentViewWidth, kContentViewHeigth - CGRectGetMaxY(_activityIndicatorView.frame))];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.textAlignment = UITextAlignmentCenter;
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        _tipsLabel.text = kStandardTips;
        
        [_contentView addSubview:_tipsLabel];
    }
    return self;
}

- (void)dealloc
{
    [_tipsLabel release];
    [_activityIndicatorView release];
    [_contentView release];
    [super dealloc];
}

#pragma mark - Public

+ (LoadingView *)sharedView
{
    static LoadingView *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return sharedInstance;
}

- (void)appearWithBlock:(BOOL)block
{
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGRect fullScreenBounds = CGRectMake(0, statusBarHeight, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - statusBarHeight);
    self.frame = fullScreenBounds;
    [self appearInView:[[UIApplication sharedApplication] keyWindow] block:block];
}

- (void)appearInViewController:(UIViewController *)viewController block:(BOOL)block
{
    self.frame = [viewController mainBounds];
    
    [self appearInView:viewController.view block:block];
}

- (void)appearInView:(UIView *)view block:(BOOL)block
{
    self.userInteractionEnabled = block;
    [self adjustSubviews];
//    ASLog(@"%@\n%@", view, _contentView);
    [_activityIndicatorView startAnimating];
    
    [view addSubview:self];
    
    //Make the view small and transparent before animation
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    //animate into full size
    //First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
    //This two-stage animation creates a little "pop" on open.
    [UIView animateWithDuration:kLoadingViewAnimateDuration delay:0.f options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)disappear
{
//    ASLog("%@",self);
    [UIView animateWithDuration:kLoadingViewAnimateDuration delay:0.f options:UIViewAnimationCurveEaseInOut animations:^{
        self.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _tipsLabel.text = kStandardTips;
        [_activityIndicatorView stopAnimating];
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0f;
    }];
}

#pragma mark - Private

- (void)adjustSubviews
{
    ASLog(@"%@",NSStringFromCGRect(self.frame));
    _contentView.center = CGPointMake(self.frame.size.width * .5, self.frame.size.height * .5);
}

@end
