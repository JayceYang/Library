//
//  UIImage+ASCategory.h
//  ASSupplement
//
//  Created by Jayce Yang on 12-7-13.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (ASCategory)

- (CGSize)sizeToFitSize:(CGSize)size;
- (UIImage *)imageToFitSize:(CGSize)size;
- (UIImage *)blackAndWhiteImage;
- (UIImage *)imageWithCorrectiveRotation;
- (NSString *)writeToPNGFileWithFileName:(NSString *)name;
- (NSString *)writeToPNGFileWithFileName:(NSString *)name atomically:(BOOL)useAuxiliaryFile;
- (NSString *)writeToJPEGFileWithFileName:(NSString *)name;
- (NSString *)writeToJPEGFileWithFileName:(NSString *)name atomically:(BOOL)useAuxiliaryFile;
- (NSString *)writeToJPEGFileWithFileName:(NSString *)name atomically:(BOOL)useAuxiliaryFile compressionQuality:(CGFloat)quality;

@end
