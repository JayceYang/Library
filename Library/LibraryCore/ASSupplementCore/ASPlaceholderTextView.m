//
//  ASPlaceholderTextView.m
//  ASSupplement
//
//  Created by Yang Jayce on 12-3-6.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "ASPlaceholderTextView.h"

@interface ASPlaceholderTextView ()

- (void)updateShouldDrawPlaceholder;
- (void)textChanged:(NSNotification *)notification;

@end


@implementation ASPlaceholderTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
        
        //self.placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
        self.placeholderColor = [UIColor lightGrayColor];
        __shouldDrawPlaceholder = NO;
    }
    return self;
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
    [_placeholder release];
    [_placeholderColor release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    if (__shouldDrawPlaceholder) {
        [_placeholderColor set];
        CGFloat x = 10.f;
        CGFloat y = 8.f;
        [_placeholder drawInRect:CGRectMake(x, y, self.frame.size.width - 2 * x, self.frame.size.height - 2 * y) withFont:self.font];
    }
}

- (void)setText:(NSString *)string 
{
    [super setText:string];
    [self updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string 
{
    if ([string isEqual:_placeholder]) {
        return;
    }
    
    [_placeholder release];
    _placeholder = [string retain];
    
    [self updateShouldDrawPlaceholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor 
{
    if ([placeholderColor isEqual:_placeholderColor] || !placeholderColor) {
        return;
    }
    
    [_placeholderColor release];
    _placeholderColor = [placeholderColor retain];
    
    [self updateShouldDrawPlaceholder];
}

#pragma mark - Private

- (void)updateShouldDrawPlaceholder 
{
    BOOL prev = __shouldDrawPlaceholder;
    __shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    
    if (prev != __shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}


- (void)textChanged:(NSNotification *)notificaiton 
{
    [self updateShouldDrawPlaceholder];    
}

@end
