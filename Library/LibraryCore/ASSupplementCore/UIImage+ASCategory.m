//
//  UIImage+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-7-13.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import "UIImage+ASCategory.h"
#import "NSObject+ASCategory.h"

typedef enum {
    ImageFileFormatPNG,
    ImageFileFormatJPEG
} ImageFileFormat;

@implementation UIImage (ASCategory)

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

- (NSString *)writeToFileWithFileName:(NSString *)name atomically:(BOOL)useAuxiliaryFile imageFileFormat:(ImageFileFormat)format compressionQuality:(CGFloat)quality
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",name];
    //ASLog(@"filePath:%@",filePath);
    if (format == ImageFileFormatPNG) {
        filePath = [filePath stringByAppendingString:@".png"];
        [UIImagePNGRepresentation(self) writeToFile:filePath atomically:useAuxiliaryFile];
    } else {
        filePath = [filePath stringByAppendingString:@".jpeg"];
        [UIImageJPEGRepresentation(self, quality) writeToFile:filePath atomically:useAuxiliaryFile];
    }
    return filePath;
}

- (NSString *)writeToPNGFileWithFileName:(NSString *)name atomically:(BOOL)useAuxiliaryFile
{
    return [self writeToFileWithFileName:name atomically:useAuxiliaryFile imageFileFormat:ImageFileFormatPNG compressionQuality:1.0f];
}

- (NSString *)writeToJPEGFileWithFileName:(NSString *)name atomically:(BOOL)useAuxiliaryFile compressionQuality:(CGFloat)quality
{
    return [self writeToFileWithFileName:name atomically:useAuxiliaryFile imageFileFormat:ImageFileFormatJPEG compressionQuality:quality];
}

@end
