//
//  UITableView+PullToLoadMore.h
//  Pulling
//
//  Created by Jayce Yang on 12-11-28.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullToLoadMoreView;

@interface UITableView (PullToLoadMore)

- (void)addPullToLoadMore;
- (void)triggerPullToLoadMore;

@property (nonatomic, strong, readonly) PullToLoadMoreView *pullToLoadMoreView;
@property (nonatomic, assign) BOOL showsPullToLoadMore;

@end


enum {
	PullToLoadMoreStateStopped = 0,
    PullToLoadMoreStateTriggered,
    PullToLoadMoreStateLoading,
    PullToLoadMoreStateAll = 10
};

typedef NSUInteger PullToLoadMoreState;

@protocol PullToLoadMoreViewDelegate;

@interface PullToLoadMoreView : UIView

@property (assign, nonatomic) id <PullToLoadMoreViewDelegate> delegate;
@property (nonatomic, readwrite) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, readonly) PullToLoadMoreState state;
@property (nonatomic, readwrite) BOOL enabled;

- (void)setCustomView:(UIView *)view forState:(PullToLoadMoreState)state;

- (void)startAnimating;
- (void)stopAnimating;

@end

@protocol PullToLoadMoreViewDelegate <NSObject>

- (void)pullToLoadMoreViewDidBeginLoadingMore;

@end