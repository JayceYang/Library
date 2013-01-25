//
//  UITableView+PullToRefresh.m
//  Pulling
//
//  Created by Jayce Yang on 12-11-28.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "UITableView+PullToRefresh.h"

static CGFloat const PullToRefreshViewHeight = 60;

@interface PullToRefreshArrow : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end


@interface PullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);

@property (nonatomic, strong) PullToRefreshArrow *arrow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, readwrite) PullToRefreshState state;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *subtitles;

@property (nonatomic, assign) UITableView *tableView;

@property (nonatomic) CGFloat originalTopInset;

@property (nonatomic) BOOL wasTriggeredByUser;
@property (nonatomic) BOOL showsPullToRefresh;
@property (nonatomic) BOOL showsDateLabel;
@property (nonatomic) BOOL isObserving;

- (void)resetTableViewContentInset;
- (void)setTableViewContentInsetForLoading;
- (void)setTableViewContentInset:(UIEdgeInsets)insets;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;

@end

#pragma mark - PullToRefresh
@implementation PullToRefreshView

// public properties
@synthesize pullToRefreshActionHandler, arrowColor, textColor, activityIndicatorViewStyle, lastUpdatedDate, dateFormatter;

@synthesize state = _state;
@synthesize tableView = _tableView;
@synthesize showsPullToRefresh = _showsPullToRefresh;
@synthesize arrow = _arrow;
@synthesize activityIndicatorView = _activityIndicatorView;

@synthesize titleLabel = _titleLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.textColor = [UIColor darkGrayColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = PullToRefreshStateStopped;
        self.showsDateLabel = NO;
        
        self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Pull to refresh...",),
                       NSLocalizedString(@"Release to refresh...",),
                       NSLocalizedString(@"Loading...",),
                       nil];
        
        self.subtitles = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.tableView. Why self.tableView == nil here?
        UITableView *tableView = (UITableView *)self.superview;
        if (tableView.showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "PullToRefreshView's dealloc", so remove observer here
                [tableView removeObserver:self forKeyPath:@"contentOffset"];
                [tableView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews
{
    CGFloat remainingWidth = self.superview.bounds.size.width-200;
    float position = 0.50;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = ceil(remainingWidth*position+44);
    self.titleLabel.frame = titleFrame;
    
    CGRect dateFrame = self.subtitleLabel.frame;
    dateFrame.origin.x = titleFrame.origin.x;
    self.subtitleLabel.frame = dateFrame;
    
    CGRect arrowFrame = self.arrow.frame;
    arrowFrame.origin.x = ceil(remainingWidth*position);
    self.arrow.frame = arrowFrame;
    
    self.activityIndicatorView.center = self.arrow.center;
    
    self.titleLabel.text = [self.titles objectAtIndex:self.state];
    
//    NSString *subtitle = [self.subtitles objectAtIndex:self.state];
//    if(subtitle.length > 0)
//        self.subtitleLabel.text = subtitle;
    
    switch (self.state) {
        case PullToRefreshStateStopped:
            self.arrow.alpha = 1;
            [self.activityIndicatorView stopAnimating];
            [self rotateArrow:0 hide:NO];
            break;
            
        case PullToRefreshStateTriggered:
            [self rotateArrow:M_PI hide:NO];
            break;
            
        case PullToRefreshStateLoading:
            self.arrow.layer.opacity = NO;      //Added by Jayce Yang
            [self.activityIndicatorView startAnimating];
            [self rotateArrow:0 hide:YES];
            break;
    }
}

#pragma mark - Scroll View

- (void)resetTableViewContentInset
{
    UIEdgeInsets currentInsets = self.tableView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setTableViewContentInset:currentInsets];
}

- (void)setTableViewContentInsetForLoading
{
    CGFloat offset = MAX(self.tableView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.tableView.contentInset;
    currentInsets.top = MIN(offset, self.originalTopInset + PullToRefreshViewHeight);
    [self setTableViewContentInset:currentInsets];
}

- (void)setTableViewContentInset:(UIEdgeInsets)contentInset
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.tableView.contentInset = contentInset;
    } completion:NULL];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
        [self tableViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if ([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)tableViewDidScroll:(CGPoint)contentOffset
{
    if (self.state != PullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalTopInset;
        
        if (!self.tableView.isDragging && self.state == PullToRefreshStateTriggered)
            self.state = PullToRefreshStateLoading;
        else if (contentOffset.y < scrollOffsetThreshold && self.tableView.isDragging && self.state == PullToRefreshStateStopped)
            self.state = PullToRefreshStateTriggered;
        else if (contentOffset.y >= scrollOffsetThreshold && self.state != PullToRefreshStateStopped)
            self.state = PullToRefreshStateStopped;
    }
}

#pragma mark - Getters

- (PullToRefreshArrow *)arrow
{
    if (!_arrow) {
		_arrow = [[PullToRefreshArrow alloc]initWithFrame:CGRectMake(0, 6, 22, 48)];
        _arrow.backgroundColor = [UIColor clearColor];
		[self addSubview:_arrow];
    }
    return _arrow;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 210, 20)];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = textColor;
        [self addSubview:_subtitleLabel];
        
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.origin.y = 12;
        self.titleLabel.frame = titleFrame;
    }
    return _subtitleLabel;
}

- (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

- (UIColor *)arrowColor
{
	return self.arrow.arrowColor; // pass through
}

- (UIColor *)textColor
{
    return self.titleLabel.textColor;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setArrowColor:(UIColor *)newArrowColor
{
	self.arrow.arrowColor = newArrowColor; // pass through
	[self.arrow setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)newTextColor
{
    textColor = newTextColor;
    self.titleLabel.textColor = newTextColor;
	self.subtitleLabel.textColor = newTextColor;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle
{
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate
{
    self.showsDateLabel = YES;
    self.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}

- (void)setDateFormatter:(NSDateFormatter *)newDateFormatter
{
	dateFormatter = newDateFormatter;
    self.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), self.lastUpdatedDate?[newDateFormatter stringFromDate:self.lastUpdatedDate]:NSLocalizedString(@"Never",)];
}

#pragma mark -

- (void)startAnimating
{
    if (self.tableView.contentOffset.y == 0) {
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, -self.frame.size.height) animated:YES];
        self.wasTriggeredByUser = NO;
    } else {
        self.wasTriggeredByUser = YES;
    }
    
    self.state = PullToRefreshStateLoading;
}

- (void)stopAnimating
{
    self.state = PullToRefreshStateStopped;
    if (!self.wasTriggeredByUser)
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, 0) animated:YES];
}

- (void)setState:(PullToRefreshState)newState
{
    if (_state == newState)
        return;
    
    PullToRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    
    switch (newState) {
        case PullToRefreshStateStopped:
            [self resetTableViewContentInset];
            break;
            
        case PullToRefreshStateTriggered:
            break;
            
        case PullToRefreshStateLoading:
            [self setTableViewContentInsetForLoading];
            if (previousState == PullToRefreshStateTriggered) {
                if (_delegate && [_delegate respondsToSelector:@selector(pullToRefreshViewDidBeginRefreshing)]) {
                    [_delegate pullToRefreshViewDidBeginRefreshing];
                }
//                pullToRefreshActionHandler();
            }
            break;
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
        //[self.arrow setNeedsDisplay];//ios 4
    } completion:NULL];
}

@end

#pragma mark - UITableView (PullToRefresh)

@implementation UITableView (PullToRefresh)

static char UITableViewPullToRefreshView;

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
    if (!self.pullToRefreshView) {
        PullToRefreshView *view = [[PullToRefreshView alloc] initWithFrame:CGRectMake(0, - PullToRefreshViewHeight, self.bounds.size.width, PullToRefreshViewHeight)];
        view.pullToRefreshActionHandler = actionHandler;
        view.tableView = self;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
    }
}

- (void)triggerPullToRefresh
{
    self.pullToRefreshView.state = PullToRefreshStateTriggered;
    [self.pullToRefreshView startAnimating];
}

- (void)setPullToRefreshView:(PullToRefreshView *)pullToRefreshView
{
    [self willChangeValueForKey:@"PullToRefreshView"];
    objc_setAssociatedObject(self, &UITableViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"PullToRefreshView"];
}

- (PullToRefreshView *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &UITableViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh
{
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    
    if (!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetTableViewContentInset];
            self.pullToRefreshView.isObserving = NO;
        }
    } else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
        }
    }
}

- (BOOL)showsPullToRefresh
{
    return !self.pullToRefreshView.hidden;
}

@end

#pragma mark - PullToRefreshArrow

@implementation PullToRefreshArrow

@synthesize arrowColor;

- (UIColor *)arrowColor
{
    if (arrowColor) {
        return arrowColor;
    } else {
        return [UIColor grayColor]; // default Color
    }
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	// the rects above the arrow
	CGContextAddRect(c, CGRectMake(5, 0, 12, 4)); // to-do: use dynamic points
	CGContextAddRect(c, CGRectMake(5, 6, 12, 4)); // currently fixed size: 22 x 48pt
	CGContextAddRect(c, CGRectMake(5, 12, 12, 4));
	CGContextAddRect(c, CGRectMake(5, 18, 12, 4));
	CGContextAddRect(c, CGRectMake(5, 24, 12, 4));
	CGContextAddRect(c, CGRectMake(5, 30, 12, 4));
	
	// the arrow
	CGContextMoveToPoint(c, 0, 34);
	CGContextAddLineToPoint(c, 11, 48);
	CGContextAddLineToPoint(c, 22, 34);
	CGContextAddLineToPoint(c, 0, 34);
	CGContextClosePath(c);
	
	CGContextSaveGState(c);
	CGContextClip(c);
	
	// Gradient Declaration
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat alphaGradientLocations[] = {0, 0.8};
    
	CGGradientRef alphaGradient = nil;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 5) {
        NSArray* alphaGradientColors = [NSArray arrayWithObjects:
                                        (id)[self.arrowColor colorWithAlphaComponent:0].CGColor,
                                        (id)[self.arrowColor colorWithAlphaComponent:1].CGColor,
                                        nil];
        alphaGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)alphaGradientColors, alphaGradientLocations);
    } else {
        const CGFloat * components = CGColorGetComponents([self.arrowColor CGColor]);
        int numComponents = CGColorGetNumberOfComponents([self.arrowColor CGColor]);
        CGFloat colors[8];
        switch (numComponents) {
            case 2:
            {
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[0];
                colors[2] = colors[6] = components[0];
                break;
            }
            case 4:
            {
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[1];
                colors[2] = colors[6] = components[2];
                break;
            }
        }
        colors[3] = 0;
        colors[7] = 1;
        alphaGradient = CGGradientCreateWithColorComponents(colorSpace,colors,alphaGradientLocations,2);
    }
	
	
	CGContextDrawLinearGradient(c, alphaGradient, CGPointZero, CGPointMake(0, rect.size.height), 0);
    
	CGContextRestoreGState(c);
	
	CGGradientRelease(alphaGradient);
	CGColorSpaceRelease(colorSpace);
}

@end
