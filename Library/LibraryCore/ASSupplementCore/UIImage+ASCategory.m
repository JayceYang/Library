//
//  UIImage+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-7-13.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "UIImage+ASCategory.h"
#import "NSObject+ASCategory.h"

NSString * const kExtensionPNG           = @"png";
NSString * const kExtensionJPEG          = @"jpeg";

@implementation UIImage (ASCategory)

+ (UIImage *)imageWithContentsOfURL:(NSURL *)URL
{
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (CGSize)sizeToFitSize:(CGSize)size
{
    if (!self || (NSInteger)fabsf(self.size.width) == 0 || (NSInteger)fabsf(self.size.height) == 0 || (NSInteger)fabsf(size.width) == 0 || (NSInteger)fabsf(size.height) == 0) {
        return CGSizeZero;
    }
    
    CGFloat factor;
	CGSize resultSize;
	
	if (self.size.width < size.width && self.size.height < size.height) {
		resultSize = self.size;
	} else {
		if (self.size.width >= self.size.height) {
			factor = size.width / self.size.width;
			resultSize.width = size.width;
			resultSize.height = self.size.height * factor;
		} else {
			factor = size.height / self.size.height;
			resultSize.height = size.height;
			resultSize.width = self.size.width * factor;
		}
	}
	return resultSize;
}

- (UIImage *)imageToFitSize:(CGSize)size
{
	CGSize fittedSize = [self sizeToFitSize:size];
	UIGraphicsBeginImageContext(size);
	CGRect rect = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
	[self drawInRect:rect];
	UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resultImage;
}

- (UIImage *)blackAndWhiteImage
{
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, self.size.width, colorSapce, kCGImageAlphaNone);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);
    
    CGImageRef blackAndWhite = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSapce);
    
    UIImage *resultImage = [UIImage imageWithCGImage:blackAndWhite]; // This is result B/W image.
    
    CGImageRelease(blackAndWhite);
    
    return resultImage;
}

- (UIImage *)imageWithCorrectiveRotation
{
    CGImageRef imageRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    
    switch(orient) {
            
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            ASLog(@"Invalid image orientation");
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imageRef);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (NSString *)writeToFileNamed:(NSString *)name
{
    return [self writeToFileNamed:name extension:kExtensionPNG];
}

- (NSString *)writeToFileNamed:(NSString *)name extension:(NSString *)extension
{
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:name];
    filePath = [filePath stringByAppendingPathExtension:extension];
    if ([extension isEqualToString:kExtensionPNG]) {
        [UIImagePNGRepresentation([self imageWithCorrectiveRotation]) writeToFile:filePath atomically:YES];
    } else {
        [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], 1.0) writeToFile:filePath atomically:YES];
    }
    return filePath;
}

- (NSString *)writeToFileNamed:(NSString *)name compressionQuality:(CGFloat)quality
{
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:name];
    filePath = [filePath stringByAppendingPathExtension:kExtensionJPEG];
    [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], quality) writeToFile:filePath atomically:YES];
    return filePath;
}

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent
{
    return [self writeToURLWithLastPathComponent:pathComponent extension:kExtensionPNG];
}

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent extension:(NSString *)extension
{
    NSURL *absoluteURL = [[[self documentsURL] URLByAppendingPathComponent:pathComponent] URLByAppendingPathExtension:extension];
    if ([extension isEqualToString:kExtensionPNG]) {
        [UIImagePNGRepresentation([self imageWithCorrectiveRotation]) writeToURL:absoluteURL atomically:YES];
    } else {
        [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], .8) writeToURL:absoluteURL atomically:YES];
    }
    return absoluteURL;
}

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent compressionQuality:(CGFloat)quality
{
    NSURL *absoluteURL = [[[self documentsURL] URLByAppendingPathComponent:pathComponent] URLByAppendingPathExtension:kExtensionJPEG];
    [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], quality) writeToURL:absoluteURL atomically:YES];
    return absoluteURL;
}

@end
