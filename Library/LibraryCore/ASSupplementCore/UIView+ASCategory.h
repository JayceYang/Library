//
//  UIImage+ASCategory.h
//  ASSupplement
//
//  Created by Yang Jayce on 12-2-7.
//  Copyright (c) 2011年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASPlaceholderTextView;

#define kButtonFontSize                     [UIFont buttonFontSize]         /* 18px */
#define kLabelFontSize                      [UIFont labelFontSize]          /* 17px */
#define kSystemFontSize                     [UIFont systemFontSize]         /* 14px */
#define kSmallSystemFontSize                [UIFont smallSystemFontSize]    /* 12px */

@interface UIView (ASCategory) 

/* traverse responder chain for the view's viewController */
- (UIViewController *)viewController;

/* load from main bundle, no cache */
- (UIImage *)imageWithContentsOfFileNamed:(NSString *)name;

- (UIImage *)imageFromView:(UIView *)view;

- (UIImage *)imageFromColor:(UIColor *)color;

- (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image;

- (UIImageView *)imageViewFromView:(UIView *)view;              

/* if the frame is CGRectZero, the button will use the image's size as its size and CGPointZero as its origin */
- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        image:(UIImage *)image;  

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image;

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation;

/* if the frame is CGRectZero, the button will use the image's size as its size and CGPointZero as its origin */
- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        title:(NSString *)title
              backgroundImage:(UIImage *)image;

/* default background color is clear color */
- (UILabel *)labelWithFrame:(CGRect)frame 
                       text:(NSString *)text 
                  textColor:(UIColor *)color 
              textAlignment:(UITextAlignment)alignment 
                       font:(UIFont *)font; 

- (UITextField *)textFieldWithFrame:(CGRect)frame 
                        borderStyle:(UITextBorderStyle)style 
                    backgroundColor:(UIColor *)backgroundColor 
                               text:(NSString *)text 
                          textColor:(UIColor *)textColor 
                      textAlignment:(UITextAlignment)alignment 
                               font:(UIFont *)font;

- (UITextView *)textViewWithFrame:(CGRect)frame 
                  backgroundColor:(UIColor *)backgroundColor
                             text:(NSString *)text 
                        textColor:(UIColor *)textColor 
                    textAlignment:(UITextAlignment)alignment 
                             font:(UIFont *)font;

- (ASPlaceholderTextView *)textViewWithFrame:(CGRect)frame 
                             backgroundColor:(UIColor *)backgroundColor
                                        text:(NSString *)text 
                                   textColor:(UIColor *)textColor 
                               textAlignment:(UITextAlignment)alignment 
                                        font:(UIFont *)font 
                                  placehoder:(NSString *)placeholder 
                            placeholderColor:(UIColor *)placeholderColor;

- (UISearchBar *)searchBarWithFrame:(CGRect)frame 
                 clearBarBackground:(BOOL)clearBar 
                    clearButtonMode:(UITextFieldViewMode)mode;

- (UISearchBar *)searchBarRoundedRectWithFrame:(CGRect)frame 
                            clearBarBackground:(BOOL)clearBar 
                               clearButtonMode:(UITextFieldViewMode)mode 
                      clearTextFieldBackground:(BOOL)clearTextField;

- (UITableView *)tableViewWithFrame:(CGRect)frame 
                              style:(UITableViewStyle)style 
                     backgroundView:(UIView *)backgroundView 
                         dataSource:(id<UITableViewDataSource>)dataSource 
                           delegate:(id<UITableViewDelegate>)delegate;

- (UISegmentedControl *)segmentedControlWithItems:(NSArray *)items 
                            segmentedControlStyle:(UISegmentedControlStyle)style 
                                        momentary:(BOOL)momentary;

- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired;

- (void)configureFrameAppendingHeight:(CGFloat)appending;

- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

@end
