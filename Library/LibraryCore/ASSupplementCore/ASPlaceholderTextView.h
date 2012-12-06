//
//  ASPlaceholderTextView.h
//  ASSupplement
//
//  Created by Yang Jayce on 12-3-6.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASPlaceholderTextView : UITextView {
@private
    BOOL __shouldDrawPlaceholder;
}

@property (copy ,nonatomic) NSString *placeholder;
@property (strong, nonatomic) UIColor *placeholderColor;

@end
