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
    CGFloat bottomToolbarHeight = self.navigationController.toolbarHidden ? 0 : self.navigationController.toolbar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - bottomToolbarHeight);
}

- (CGRect)mainBoundsMinusHeight:(CGFloat)minus
{
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabBarHeight = self.hidesBottomBarWhenPushed ? 0 : self.tabBarController.tabBar.bounds.size.height;
    CGFloat bottomToolbarHeight = self.navigationController.toolbarHidden ? 0 : self.navigationController.toolbar.bounds.size.height;
    return CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - navigationBarHeight - tabBarHeight - bottomToolbarHeight - minus);
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
