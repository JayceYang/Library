//
//  UIDevice+ASCategory.m
//  Library from uidevice-extension
//
//  Created by Jayce Yang on 12-12-22.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <mach/mach.h>

#import "UIDevice+ASCategory.h"

NSString * const iFPGA                      = @"iFPGA";

NSString * const iPhone1G                   = @"iPhone 1G";
NSString * const iPhone3G                   = @"iPhone 3G";
NSString * const iPhone3GS                  = @"iPhone 3GS";
NSString * const iPhone4                    = @"iPhone 4";
NSString * const iPhone4S                   = @"iPhone 4S";
NSString * const iPhone5                    = @"iPhone 5";
NSString * const UnknowniPhone              = @"Unknown iPhone";

NSString * const iPodtouch1G                = @"iPod touch 1G";
NSString * const iPodtouch2G                = @"iPod touch 2G";
NSString * const iPodtouch3G                = @"iPod touch 3G";
NSString * const iPodtouch4G                = @"iPod touch 4G";
NSString * const iPodtouch5G                = @"iPod touch 5G";
NSString * const UnknowniPod                = @"Unknown iPod";

NSString * const iPad1G                     = @"iPad 1G";
NSString * const iPad2G                     = @"iPad 2G";
NSString * const iPad3G                     = @"iPad 3G";
NSString * const iPad4G                     = @"iPad 4G";
NSString * const UnknowniPad                = @"Unknown iPad";

NSString * const AppleTV2G                  = @"Apple TV 2G";
NSString * const AppleTV3G                  = @"Apple TV 3G";
NSString * const AppleTV4G                  = @"Apple TV 4G";
NSString * const UnknownAppleTV             = @"Unknown Apple TV";

NSString * const UnknowniOSDevice           = @"Unknown iOS device";

NSString * const iPhoneSimulator            = @"iPhone Simulator";
NSString * const iPadSimulator              = @"iPad Simulator";
NSString * const AppleTVSimulator           = @"Apple TV Simulator";

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceSimulatoriPhone,
    UIDeviceSimulatoriPad,
    UIDeviceSimulatorAppleTV,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice4SiPhone,
    UIDevice5iPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    UIDevice5GiPod,
    
    UIDevice1GiPad,
    UIDevice2GiPad,
    UIDevice3GiPad,
    UIDevice4GiPad,
    
    UIDeviceAppleTV2,
    UIDeviceAppleTV3,
    UIDeviceAppleTV4,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceUnknownAppleTV,
    UIDeviceIFPGA,
    
} UIDevicePlatform;

@implementation UIDevice (ASCategory)

#pragma mark - Public

- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return 0;
    }
    
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

- (double)memoryUsedByCurrentTask
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return 0;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (BOOL)hasRetinaDisplay
{
    return ([UIScreen mainScreen].scale == 2.0f);
}

- (BOOL)padDeviceModel
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO;
}

- (NSString *)detailModel
{
    switch ([self platformType]) {
        case UIDevice1GiPhone:
            return iPhone1G;
        case UIDevice3GiPhone:
            return iPhone3G;
        case UIDevice3GSiPhone:
            return iPhone3GS;
        case UIDevice4iPhone:
            return iPhone4;
        case UIDevice4SiPhone:
            return iPhone4S;
        case UIDevice5iPhone:
            return iPhone5;
        case UIDeviceUnknowniPhone:
            return UnknowniPhone;
            
        case UIDevice1GiPod:
            return iPodtouch1G;
        case UIDevice2GiPod:
            return iPodtouch2G;
        case UIDevice3GiPod:
            return iPodtouch3G;
        case UIDevice4GiPod:
            return iPodtouch4G;
        case UIDevice5GiPod:
            return iPodtouch5G;
        case UIDeviceUnknowniPod:
            return UnknowniPod;
            
        case UIDevice1GiPad :
            return iPad1G;
        case UIDevice2GiPad :
            return iPad2G;
        case UIDevice3GiPad :
            return iPad3G;
        case UIDevice4GiPad :
            return iPad4G;
        case UIDeviceUnknowniPad :
            return UnknowniPad;
            
        case UIDeviceAppleTV2 :
            return AppleTV2G;
        case UIDeviceAppleTV3 :
            return AppleTV3G;
        case UIDeviceAppleTV4 :
            return AppleTV4G;
        case UIDeviceUnknownAppleTV:
            return UnknownAppleTV;
            
        case UIDeviceSimulatoriPhone:
            return iPhoneSimulator;
        case UIDeviceSimulatoriPad:
            return iPadSimulator;
        case UIDeviceSimulatorAppleTV:
            return AppleTVSimulator;
            
        case UIDeviceIFPGA:
            return iFPGA;
            
        default:
            return UnknowniOSDevice;
    }
}

- (UIDeviceFamily)deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"])
        return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"])
        return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"])
        return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"])
        return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

- (NSString *)UUID
{
    CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, UUIDRef);
    CFRelease(UUIDRef);
    return [(id)stringRef autorelease];
}

- (NSString *)MACAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

#pragma mark - Private

- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *)platform
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *)hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

- (NSUInteger)platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])
        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])
        return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])
        return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])
        return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])
        return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])
        return UIDevice4SiPhone;
    if ([platform hasPrefix:@"iPhone5"])
        return UIDevice5iPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])
        return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])
        return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])
        return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])
        return UIDevice4GiPod;
    if ([platform hasPrefix:@"iPod5"])
        return UIDevice5GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])
        return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])
        return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])
        return UIDevice3GiPad;
    if ([platform hasPrefix:@"iPad4"])
        return UIDevice4GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])
        return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])
        return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])
        return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])
        return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])
        return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])
        return UIDeviceUnknownAppleTV;
    
    // Simulator 
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

@end
