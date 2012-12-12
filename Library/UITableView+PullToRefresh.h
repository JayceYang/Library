//
//  UITableView+PullToRefresh.h
//  Pulling
//
//  Created by Jayce Yang on 12-11-28.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullToRefreshView;

@interface UITableView (PullToRefresh)

- (void)addPullToRefresh;
- (void)triggerPullToRefresh;

@property (nonatomic, strong, readonly) PullToRefreshView *pullToRefreshView;
@property (nonatomic) BOOL showsPullToRefresh;

@end

enum {
    PullToRefreshStateStopped = 0,
    PullToRefreshStateTriggered,
    PullToRefreshStateLoading,
    PullToRefreshStateAll = 10
};

typedef NSUInteger PullToRefreshState;

@protocol PullToRefreshViewDelegate;

@interface PullToRefreshView : UIView

@property (assign, nonatomic) id <PullToRefreshViewDelegate> delegate;

@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, readonly) PullToRefreshState state;

- (void)setTitle:(NSString *)title forState:(PullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(PullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(PullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

// deprecated; use setSubtitle:forState: instead
@property (nonatomic, strong, readonly) UILabel *dateLabel DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDate *lastUpdatedDate DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDateFormatter *dateFormatter DEPRECATED_ATTRIBUTE;

// deprecated; use [self.scrollView triggerPullToRefresh] instead
- (void)triggerRefresh DEPRECATED_ATTRIBUTE;

@end

@protocol PullToRefreshViewDelegate <NSObject>

- (void)pullToRefreshViewDidBeginRefreshing;

@end