//
//  LoadingView.h
//  PhoneOnline
//
//  Created by Jayce Yang on 12-9-22.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kContentViewWidth   100
#define kContentViewHeigth  100

#define kStandardTips       @"请稍候..."

@interface LoadingView : UIView {
@private
    UIView                  *_contentView;
    UIActivityIndicatorView *_activityIndicatorView;
    UILabel                 *_tipsLabel;
}

@property (readonly, strong, nonatomic) UILabel *tipsLabel;

+ (LoadingView *)sharedView;

- (void)appearWithBlock:(BOOL)block;    //show in keyWindow
- (void)appearInViewController:(UIViewController *)viewController block:(BOOL)block;
- (void)disappear;

@end
