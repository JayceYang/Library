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

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
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

@property (nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSDate *lastUpdatedDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;

@property (nonatomic, readonly) PullToRefreshState state;

- (void)startAnimating;
- (void)stopAnimating;

@end

@protocol PullToRefreshViewDelegate <NSObject>

- (void)pullToRefreshViewDidBeginRefreshing;

@end