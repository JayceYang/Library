//
//  NSObject+ASCategory.m
//  ASSupplement
//
//  Created by Jayce Yang on 12-10-25.
//  Copyright (c) 2012年 Personal. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

#import "NSObject+ASCategory.h"
#import "NSDate+ASCategory.h"

inline BOOL doubleEqualToDouble(double double1, double double2)
{
    return fabs(double1 - double2) <= pow(10, - 6);
}

inline BOOL doubleEqualToDoubleWithAccuracyExponent(double double1, double double2 ,int accuracyExponent)
{
    return fabs(double1 - double2) <= pow(10, - accuracyExponent);
}

inline BOOL CLLocationCoordinate2DEqualToCoordinate(CLLocationCoordinate2D coordinate1, CLLocationCoordinate2D coordinate2)
{
    return coordinate1.latitude == coordinate2.latitude && coordinate1.longitude == coordinate2.longitude;
}

inline CLLocationDistance metersBetweenLocationCoordinates(CLLocationCoordinate2D userLocationCoordinate, CLLocationCoordinate2D coordinate)
{
    MKMapPoint userLocationMapPoint = MKMapPointForCoordinate(userLocationCoordinate);
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    CLLocationDistance distance = MKMetersBetweenMapPoints(mapPoint, userLocationMapPoint);
    return distance;
}

@implementation NSObject (ASCategory)

- (NSInteger)integerValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    } else {
        return 0;
    }
}

- (BOOL)boolValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

- (NSString *)stringValueFromValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    } else {
        return [NSString string];
    }
}

- (NSDictionary *)dictionaryValueFromValue:(id)value
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return [NSDictionary dictionary];
    }
}

- (void)standardUserDefaultsSetObject:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

- (NSString *)bundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

/*
 Recommended Keys for iOS Apps
 It is recommended that an iOS app include the following keys in its information property list file. Most are set by Xcode automatically when you create your project.
 
 CFBundleDevelopmentRegion
 CFBundleDisplayName
 CFBundleExecutable
 CFBundleIconFiles
 CFBundleIdentifier
 CFBundleInfoDictionaryVersion
 CFBundlePackageType
 CFBundleVersion
 LSRequiresIPhoneOS
 UIMainStoryboardFile
 In addition to these keys, there are several that are commonly included:
 
 UIRequiredDeviceCapabilities (required)
 UIStatusBarStyle
 UIInterfaceOrientation
 UIRequiresPersistentWiFi
*/
- (NSString *)bundleDisplayName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

- (NSString *)countryCode
{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return countryCode;
}

- (NSString *)launchImageName
{
    NSString *launchImageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImageFile"];
    NSMutableString *result = nil;
    if (launchImageName.length > 0) {
        if (CGRectGetHeight([UIScreen mainScreen].bounds) > 480) {
            result = [[launchImageName mutableCopy] autorelease];
            NSRange range = [result rangeOfString:@"." options:NSBackwardsSearch];
            NSUInteger length = range.length;
            NSUInteger location = range.location;
            if (length > 0 && location > 0 && location < result.length - 1) {
                [result insertString:@"-568h" atIndex:location];
            }
            return [[result copy] autorelease];
        } else {
            return launchImageName;
        }
    } else {
        return nil;
    }
}

- (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (NSURL *)cacheURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)documentsURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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

- (UITabBarController *)tabBarControllerWithViewControllerClassNames:(NSArray *)names
{
    return [self tabBarControllerWithViewControllerClassNames:names navigated:NO];
}

- (UITabBarController *)tabBarControllerWithViewControllerClassNames:(NSArray *)names navigated:(BOOL)navigated
{
    if ([names count] > 0) {
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (NSString *viewControllerName in names) {
            NSString *targetClassName = [self stringValueFromValue:viewControllerName];
            if ([targetClassName length] > 0) {
                Class targetClass = NSClassFromString(targetClassName);
                if (targetClass) {
                    UIViewController *viewController = [[targetClass alloc] init];
                    if (navigated) {
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                        [viewControllers addObject:navigationController];
                        [navigationController release];
                    } else {
                        [viewControllers addObject:viewController];
                    }
                    [viewController release];
                }
            }
        }
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.viewControllers = viewControllers;
        return [tabBarController autorelease];
    } else {
        return nil;
    }
}

@end
