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

- (NSString *)writeToFileNamed:(NSString *)name;
- (NSString *)writeToFileNamed:(NSString *)name extension:(NSString *)extension;

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent;
- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent extension:(NSString *)extension;

@end

extern NSString * const kExtensionPNG;
extern NSString * const kExtensionJPEG;