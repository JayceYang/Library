//
//  UITableView+PullToLoadMore.m
//  Pulling
//
//  Created by Jayce Yang on 12-11-28.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UITableView+PullToLoadMore.h"

static CGFloat const PullToLoadMoreViewHeight = 44;

@interface PullToLoadMoreDotView : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end

@interface PullToLoadMoreView ()

@property (nonatomic, copy) void (^pullToLoadMoreHandler)(void);

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readwrite) PullToLoadMoreState state;
@property (nonatomic, strong) NSMutableArray *viewForState;
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, strong) UIView *originalTableFooterView;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToLoadMore;
@property (nonatomic, assign) BOOL isObserving;

- (void)resetTableViewContentInset;
- (void)setTableViewContentInsetForPullToLoadMore;
- (void)setTableViewContentInset:(UIEdgeInsets)insets;

@end

#pragma mark - UITableView (PullToLoadMoreView)

static char UITableViewPullToLoadMoreView;
UIEdgeInsets tableViewOriginalContentInsets;

@implementation UITableView (PullToLoadMore)

@dynamic pullToLoadMoreView;
@dynamic showsPullToLoadMore;

- (void)addPullToLoadMore
{
    if (!self.pullToLoadMoreView) {
        PullToLoadMoreView *view = [[PullToLoadMoreView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, PullToLoadMoreViewHeight)];
//        view.pullToLoadMoreHandler = actionHandler;
        view.tableView = self;
//        view.originalBottomInset = self.contentInset.bottom;
        view.originalTableFooterView = self.tableFooterView;
//        self.tableFooterView = view;
        [self addSubview:view];
//        NSLog(@"%f",view.originalBottomInset);
        
        view.originalBottomInset = self.contentInset.bottom;
        self.pullToLoadMoreView = view;
        self.showsPullToLoadMore = YES;
    }
}

- (void)triggerPullToLoadMore
{
    self.pullToLoadMoreView.state = PullToLoadMoreStateTriggered;
    [self.pullToLoadMoreView startAnimating];
}

- (void)setPullToLoadMoreView:(PullToLoadMoreView *)pullToLoadMoreView
{
    [self willChangeValueForKey:@"UITableViewPullToLoadMoreView"];
    objc_setAssociatedObject(self, &UITableViewPullToLoadMoreView,
                             pullToLoadMoreView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UITableViewPullToLoadMoreView"];
}

- (PullToLoadMoreView *)pullToLoadMoreView
{
    return objc_getAssociatedObject(self, &UITableViewPullToLoadMoreView);
}

- (void)setShowsPullToLoadMore:(BOOL)showsPullToLoadMore
{
//    self.pullToLoadMoreView.showsPullToLoadMore = showsPullToLoadMore;
    
    self.pullToLoadMoreView.hidden = !showsPullToLoadMore;
    
    if (!showsPullToLoadMore) {
        if (self.pullToLoadMoreView.isObserving) {
            [self removeObserver:self.pullToLoadMoreView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToLoadMoreView forKeyPath:@"contentSize"];
            [self.pullToLoadMoreView resetTableViewContentInset];
            self.pullToLoadMoreView.isObserving = NO;
//            self.tableFooterView = self.pullToLoadMoreView.originalTableFooterView;
        }
    } else {
        if (!self.pullToLoadMoreView.isObserving) {
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToLoadMoreView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self.pullToLoadMoreView setTableViewContentInsetForPullToLoadMore];
            self.pullToLoadMoreView.isObserving = YES;
//            self.tableFooterView = self.pullToLoadMoreView;
        }
    }
}

//- (BOOL)showsPullToLoadMore
//{
//    return self.pullToLoadMoreView.showsPullToLoadMore;
//}

- (BOOL)showsPullToLoadMore {
    return !self.pullToLoadMoreView.hidden;
}

@end


#pragma mark - PullToLoadMoreView
@implementation PullToLoadMoreView

// public properties
@synthesize pullToLoadMoreHandler, activityIndicatorViewStyle;

@synthesize state = _state;
@synthesize tableView = _tableView;
@synthesize activityIndicatorView = _activityIndicatorView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = PullToLoadMoreStateStopped;
        self.enabled = YES;
        
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (self.superview && newSuperview == nil) {
        UITableView *tableView = (UITableView *)self.superview;
        if (tableView.showsPullToLoadMore) {
            if (self.isObserving) {
                [tableView removeObserver:self forKeyPath:@"contentOffset"];
                [tableView removeObserver:self forKeyPath:@"contentSize"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews
{
    self.activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark - Scroll View

- (void)resetTableViewContentInset
{
    UIEdgeInsets currentInsets = self.tableView.contentInset;
    currentInsets.bottom = self.originalBottomInset;
    [self setTableViewContentInset:currentInsets];
}

- (void)setTableViewContentInsetForPullToLoadMore
{
    UIEdgeInsets currentInsets = self.tableView.contentInset;
    currentInsets.bottom = self.originalBottomInset + PullToLoadMoreViewHeight;
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
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self tableViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    } else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, self.tableView.contentSize.height, self.bounds.size.width, PullToLoadMoreViewHeight);
    }
}

- (void)tableViewDidScroll:(CGPoint)contentOffset
{
    if (self.state != PullToLoadMoreStateLoading && self.enabled) {
        CGFloat tableViewContentHeight = self.tableView.contentSize.height;
        CGFloat scrollOffsetThreshold = tableViewContentHeight-self.tableView.bounds.size.height;
        
        if (!self.tableView.isDragging && self.state == PullToLoadMoreStateTriggered && !self.tableView.isDragging) {
            self.state = PullToLoadMoreStateLoading;
        } else if (contentOffset.y > scrollOffsetThreshold && self.state == PullToLoadMoreStateStopped && self.tableView.isDecelerating) {
            self.state = PullToLoadMoreStateTriggered;
        } else if (contentOffset.y < scrollOffsetThreshold && self.state != PullToLoadMoreStateStopped) {
            self.state = PullToLoadMoreStateStopped;
        }
    }
}

#pragma mark - Getters

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setCustomView:(UIView *)view forState:(PullToLoadMoreState)state
{
    id viewPlaceholder = view;
    
    if (!viewPlaceholder)
        viewPlaceholder = @"";
    
    if (state == PullToLoadMoreStateAll) {
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    } else {
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
    }
    
    self.state = self.state;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle
{
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

#pragma mark -

- (void)startAnimating
{
    self.state = PullToLoadMoreStateLoading;
}

- (void)stopAnimating
{
    self.state = PullToLoadMoreStateStopped;
}

- (void)setState:(PullToLoadMoreState)newState
{
    if (_state == newState)
        return;
    
    PullToLoadMoreState previousState = _state;
    _state = newState;
    
    for (id otherView in self.viewForState) {
        if ([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:newState];
    BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
    if (hasCustomView) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(round((self.bounds.size.width-viewBounds.size.width)/2), round((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    } else {
        CGRect viewBounds = [self.activityIndicatorView bounds];
        CGPoint origin = CGPointMake(round((self.bounds.size.width-viewBounds.size.width)/2), round((self.bounds.size.height-viewBounds.size.height)/2));
        [self.activityIndicatorView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
        
        switch (newState) {
            case PullToLoadMoreStateStopped:
                [self.activityIndicatorView stopAnimating];
                break;
                
            case PullToLoadMoreStateTriggered:
                break;
                
            case PullToLoadMoreStateLoading:
                [self.activityIndicatorView startAnimating];
                break;
        }
    }
    
    if (previousState == PullToLoadMoreStateTriggered && newState == PullToLoadMoreStateLoading && self.enabled) {
        if (_delegate && [_delegate respondsToSelector:@selector(pullToLoadMoreViewDidBeginLoadingMore)]) {
            [_delegate pullToLoadMoreViewDidBeginLoadingMore];
        }
//        self.pullToLoadMoreHandler();
    }
}

@end