//
//  UIViewController+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-7-30.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "UIViewController+ASCategory.h"
#import "UIView+ASCategory.h"
#import "NSObject+ASCategory.h"
#import "LoadingView.h"

@implementation UIViewController (ASCategory)

#pragma mark - Compatible

- (void)presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion animated:(BOOL)flag
{
    if (SystemVersionGreaterThanOrEqualTo5) {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [self presentModalViewController:viewControllerToPresent animated:flag];
    }
}

- (void)dismissViewControllerCompletion:(void (^)(void))completion animated:(BOOL)flag
{
    if (SystemVersionGreaterThanOrEqualTo5) {
        [self dismissViewControllerAnimated:flag completion:completion];
    } else {
        [self dismissModalViewControllerAnimated:flag];
    }
}

- (void)configureLeftBarButtonUniformly
{
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:@selector(back:) image:[UIImage imageNamed:@"back_button.png"]]] autorelease];
}

- (void)configureLeftBarButtonItemImage:(UIImage *)image leftBarButtonItemAction:(SEL)action
{
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:action image:image]] autorelease];
}

- (void)configureRightBarButtonItemImage:(UIImage *)image rightBarButtonItemAction:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[self.view buttonWithFrame:CGRectZero target:self action:action image:image]] autorelease];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (CGRect)mainBounds
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight);
}

- (CGRect)mainBoundsMinusHeight:(CGFloat)minus
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - minus);
}

- (CGPoint)center
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return CGPointMake(CGRectGetWidth(self.view.bounds) * .5, CGRectGetHeight(self.view.bounds) * .5);
    } else {
        return CGPointMake(CGRectGetHeight(self.view.bounds) * .5, CGRectGetWidth(self.view.bounds) * .5);
    }
}

- (void)showLoadingView
{
    [[LoadingView sharedView] appearInViewController:self block:YES];
}

- (void)hideLoadingView
{
    [[LoadingView sharedView] disappear];
}

@end
