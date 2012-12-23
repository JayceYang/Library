//
//  UIDevice+ASCategory.h
//  Library
//
//  Created by Jayce Yang on 12-12-22.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
} UIDeviceFamily;

@interface UIDevice (ASCategory)

- (double)availableMemory;  //(单位：MB）
- (double)memoryUsedByCurrentTask;   //(单位：MB）
- (NSNumber *)totalDiskSpace;
- (NSNumber *)freeDiskSpace;

- (BOOL)hasRetinaDisplay;
- (BOOL)padDeviceModel;

- (UIDeviceFamily)deviceFamily;
- (NSString *)detailModel;

- (NSString *)UUID;
- (NSString *)MACAddress;

@end

extern NSString * const iFPGA;

extern NSString * const iPhone1G;
extern NSString * const iPhone3G;
extern NSString * const iPhone3GS;
extern NSString * const iPhone4;
extern NSString * const iPhone4S;
extern NSString * const iPhone5;
extern NSString * const UnknowniPhone;

extern NSString * const iPodtouch1G;
extern NSString * const iPodtouch2G;
extern NSString * const iPodtouch3G;
extern NSString * const iPodtouch4G;
extern NSString * const UnknowniPod;

extern NSString * const iPad1G;
extern NSString * const iPad2G;
extern NSString * const iPad3G;
extern NSString * const iPad4G;
extern NSString * const UnknowniPad;

extern NSString * const AppleTV2G;
extern NSString * const AppleTV3G;
extern NSString * const AppleTV4G;
extern NSString * const UnknownAppleTV;

extern NSString * const UnknowniOSDevice;

extern NSString * const iPhoneSimulator;
extern NSString * const iPadSimulator;
extern NSString * const AppleTVSimulator;