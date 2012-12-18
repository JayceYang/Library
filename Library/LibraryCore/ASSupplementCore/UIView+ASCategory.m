//
//  UIImage+ASCategory.m
//  ASSupplement
//
//  Created by Yang Jayce on 12-2-7.
//  Copyright (c) 2011年 Personal. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+ASCategory.h"
#import "ASPlaceholderTextView.h"

@implementation UIView (ASCategory)

- (UIViewController *)viewController
{
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIImage *)imageWithContentsOfFileNamed:(NSString *)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    if (filePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        return image;
    } else {
        return nil;
    }
}

- (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return [imageView autorelease];
}

- (UIImageView *)imageViewFromView:(UIView *)view
{
    return [[[UIImageView alloc] initWithImage:[self imageFromView:view]] autorelease];
}

- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat top = (frame.size.height - height) * .5;
    CGFloat left = 0;
    CGFloat bottom = top;
    CGFloat right = frame.size.width - width;
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat top = (frame.size.height - height) * .5;
    CGFloat left = indentation;
    CGFloat bottom = top;
    CGFloat right = frame.size.width - left - width;
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, left, 0, 0)];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        title:(NSString *)title
              backgroundImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

- (UILabel *)labelWithFrame:(CGRect)frame 
                       text:(NSString *)text 
                  textColor:(UIColor *)color 
              textAlignment:(UITextAlignment)alignment 
                       font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return [label autorelease];
}

- (UITextField *)textFieldWithFrame:(CGRect)frame
                        borderStyle:(UITextBorderStyle)style
                    backgroundColor:(UIColor *)backgroundColor
                               text:(NSString *)text 
                          textColor:(UIColor *)textColor 
                      textAlignment:(UITextAlignment)alignment 
                               font:(UIFont *)font;
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = style;
    textField.backgroundColor = backgroundColor;
    textField.text = text;
    textField.textColor = textColor;
    textField.textAlignment = alignment;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = font;
    return [textField autorelease];
}

- (UITextView *)textViewWithFrame:(CGRect)frame 
                  backgroundColor:(UIColor *)backgroundColor
                             text:(NSString *)text 
                        textColor:(UIColor *)textColor 
                    textAlignment:(UITextAlignment)alignment 
                             font:(UIFont *)font;
{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.backgroundColor = backgroundColor;
    textView.text = text;
    textView.textColor = textColor;
    textView.textAlignment = alignment;
    textView.font = font;
    return [textView autorelease];
}

- (ASPlaceholderTextView *)textViewWithFrame:(CGRect)frame 
                             backgroundColor:(UIColor *)backgroundColor
                                        text:(NSString *)text 
                                   textColor:(UIColor *)textColor 
                               textAlignment:(UITextAlignment)alignment 
                                        font:(UIFont *)font 
                                  placehoder:(NSString *)placeholder 
                            placeholderColor:(UIColor *)placeholderColor 
{
    ASPlaceholderTextView *textView = [[ASPlaceholderTextView alloc] initWithFrame:frame];
    textView.backgroundColor = backgroundColor;
    textView.text = text;
    textView.textColor = textColor;
    textView.textAlignment = alignment;
    textView.font = font;
    textView.placeholder = placeholder;
    textView.placeholderColor = placeholderColor;
    return [textView autorelease];
}

- (UISearchBar *)searchBarWithFrame:(CGRect)frame 
                 clearBarBackground:(BOOL)clearBar 
                    clearButtonMode:(UITextFieldViewMode)mode
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    for (UIView *view in searchBar.subviews) {
        if (clearBar && [view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.clearButtonMode = mode;
        }
    }
    return [searchBar autorelease];
}

- (UISearchBar *)searchBarRoundedRectWithFrame:(CGRect)frame 
                            clearBarBackground:(BOOL)clearBar 
                               clearButtonMode:(UITextFieldViewMode)mode 
                      clearTextFieldBackground:(BOOL)clearTextField
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    for (UIView *view in searchBar.subviews) {
        if (clearBar && [view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.clearButtonMode = mode;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            if (clearTextField) {
                [[textField.subviews lastObject] removeFromSuperview];
            }
        }
    }
    return [searchBar autorelease];
}

- (UITableView *)tableViewWithFrame:(CGRect)frame 
                              style:(UITableViewStyle)style 
                     backgroundView:(UIView *)backgroundView 
                         dataSource:(id<UITableViewDataSource>)dataSource 
                           delegate:(id<UITableViewDelegate>)delegate
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.backgroundView = backgroundView;
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    return [tableView autorelease];
}

- (UISegmentedControl *)segmentedControlWithItems:(NSArray *)items 
                            segmentedControlStyle:(UISegmentedControlStyle)style 
                                        momentary:(BOOL)momentary
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedControl.segmentedControlStyle = style;
    segmentedControl.momentary = momentary;
    return [segmentedControl autorelease];
}

- (void)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
}

- (void)configureFrameAppendingHeight:(CGFloat)appending
{
    CGRect rect = self.frame;
    rect.size.height += appending;
    self.frame = rect;
}

- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
}

@end
