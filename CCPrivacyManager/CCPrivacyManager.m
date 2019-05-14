//
//  CCPrivacyManager.h
//
//  Copyright © 2019 侯文富. All rights reserved.


#import "CCPrivacyManager.h"
#import <UserNotifications/UserNotifications.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <ContactsUI/ContactsUI.h>
#import <EventKit/EventKit.h>
#import <CoreLocation/CoreLocation.h>

const NSString *InfoPlistKeyMap[] = {
//    [CCPrivacyTypeNotification]             = @"",
    [CCPrivacyTypeCamera]                   = @"NSCameraUsageDescription",
    [CCPrivacyTypePhotoLibrary]             = @"NSPhotoLibraryUsageDescription",
    [CCPrivacyTypeContacts]                 = @"NSContactsUsageDescription",
    [CCPrivacyTypeCalendars]                = @"NSCalendarsUsageDescription",
    [CCPrivacyTypeMicrophone]               = @"NSMicrophoneUsageDescription",
    [CCPrivacyTypeLocationWhenInUse]        = @"NSLocationWhenInUseUsageDescription",
    [CCPrivacyTypeLocationAlways]           = @"NSLocationAlwaysUsageDescription",
//    [CCPrivacyTypeBluetoothPeripheral]      = @"NSBluetoothPeripheralUsageDescription",
//    [CCPrivacyTypeSpeechRecognition]        = @"NSSpeechRecognitionUsageDescription",
//    [CCPrivacyTypeLocationUsage]            = @"NSLocationUsageUsageDescription",
//    [CCPrivacyTypeMediaLibrary]             = @"NSMediaLibraryUsageDescription",
//    [CCPrivacyTypeHealthShare]              = @"NSHealthShareUsageDescription",
//    [CCPrivacyTypeHealthUpdate]             = @"NSHealthUpdateUsageDescription",
//    [CCPrivacyTypeMotion]                   = @"NSMotionUsageDescription",
//    [CCPrivacyTypeMusic]                    = @"NSMusicUsageDescription",
//    [CCPrivacyTypeReminders]                = @"NSRemindersUsageDescription",
//    [CCPrivacyTypeSiri]                     = @"NSSiriUsageDescription",
//    [CCPrivacyTypeTVProvider]               = @"NSTVProviderUsageDescription",
//    [CCPrivacyTypeVideoSubscriberAccount]   = @"NSVideoSubscriberAccountUsageDescription"
};

const NSString *PrivacyNameMap[] = {
    [CCPrivacyTypeNotification]             = @"通知",
    [CCPrivacyTypeCamera]                   = @"相机",
    [CCPrivacyTypePhotoLibrary]             = @"照片",
    [CCPrivacyTypeContacts]                 = @"通讯录",
    [CCPrivacyTypeCalendars]                = @"日历",
    [CCPrivacyTypeMicrophone]               = @"麦克风",
    [CCPrivacyTypeLocationWhenInUse]        = @"定位服务",
    [CCPrivacyTypeLocationAlways]           = @"定位服务",
//    [CCPrivacyTypeSpeechRecognition]        = @"语音识别",
//    [CCPrivacyTypeBluetoothPeripheral]      = @"蓝牙共享",
//    [CCPrivacyTypeLocationUsage]            = @"HomeKit",
//    [CCPrivacyTypeMediaLibrary]             = @"媒体库",
//    [CCPrivacyTypeHealthShare]              = @"健康",
//    [CCPrivacyTypeHealthUpdate]             = @"健康",
//    [CCPrivacyTypeMotion]                   = @"运动与健身",
//    [CCPrivacyTypeMusic]                    = @"音乐",
//    [CCPrivacyTypeReminders]                = @"提醒",
//    [CCPrivacyTypeSiri]                     = @"Siri",
//    [CCPrivacyTypeTVProvider]               = @"NSTVProviderUsageDescription",
//    [CCPrivacyTypeVideoSubscriberAccount]   = @"NSVideoSubscriberAccountUsageDescription"
};

@interface CCPrivacyManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) void(^handler)(CCAuthorizationStatus status);

@end

@implementation CCPrivacyManager

+ (instancetype)sharedInstance {
    static CCPrivacyManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[CCPrivacyManager alloc] init];
        }
    });
    return instance;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

+ (CCAuthorizationStatus)authorizationStatusForPrivacyType:(CCPrivacyType)type {

    if (type != CCPrivacyTypeNotification) {
        NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
        NSString *value = infoDic[InfoPlistKeyMap[type]];
        if (value.length == 0) {
            return CCAuthorizationStatusNotInfoPlist;
        }
    }

    switch (type) {
        case CCPrivacyTypeNotification:
            return [[CCPrivacyManager sharedInstance] notificationAuthorizationStatus];
            break;
        case CCPrivacyTypeCamera:
            return [[CCPrivacyManager sharedInstance] cameraAuthorizationStatus];
            break;
        case CCPrivacyTypePhotoLibrary:
            return [[CCPrivacyManager sharedInstance] photoLibraryAuthorizationStatus];
            break;
        case CCPrivacyTypeContacts:
            return [[CCPrivacyManager sharedInstance] contactsAuthorizationStatus];
            break;
        case CCPrivacyTypeCalendars:
            return [[CCPrivacyManager sharedInstance] calendarsAuthorizationStatus];
            break;
        case CCPrivacyTypeLocationWhenInUse:
        case CCPrivacyTypeLocationAlways:
            return [[CCPrivacyManager sharedInstance] locationAuthorizationStatus];
            break;
        default:
            return CCAuthorizationStatusAuthorized;
            break;
    }
}

+ (void)requestAuthorizationForPrivacyType:(CCPrivacyType)type handler:(void(^)(CCAuthorizationStatus status))handler {
    [CCPrivacyManager requestAuthorizationForPrivacyType:type fromVC:nil handler:handler];
}

+ (void)requestAuthorizationForPrivacyType:(CCPrivacyType)type fromVC:(UIViewController *)vc handler:(void(^)(CCAuthorizationStatus status))handler {
    CCAuthorizationStatus status = [CCPrivacyManager authorizationStatusForPrivacyType:type];
    [CCPrivacyManager sharedInstance].handler = handler;
    if (status == CCAuthorizationStatusNotDetermined) {
        switch (type) {
            case CCPrivacyTypeNotification:
                [[CCPrivacyManager sharedInstance] requestNotificationAuthorization:handler];
                break;
            case CCPrivacyTypeCamera:
                [[CCPrivacyManager sharedInstance] requestCamaraAuthorization:handler];
                break;
            case CCPrivacyTypePhotoLibrary:
                [[CCPrivacyManager sharedInstance] requestPhotoLibraryAuthorization:handler];
                break;
            case CCPrivacyTypeContacts:
                [[CCPrivacyManager sharedInstance] requestContactsAuthorization:handler];
                break;
            case CCPrivacyTypeCalendars:
                [[CCPrivacyManager sharedInstance] requestCalendarsAuthorization:handler];
                break;
            case CCPrivacyTypeLocationWhenInUse:
                [[CCPrivacyManager sharedInstance] requestLocationWhenInUseAuthorization:handler];
                break;
            case CCPrivacyTypeLocationAlways:
                [[CCPrivacyManager sharedInstance] requestLocationAlwaysAuthorization:handler];
                break;
            default:
                break;
        }
    } else {
        if (handler) {
            handler(status);
        }
        // alert提示
        if (vc) {
            if (status == CCAuthorizationStatusNotInfoPlist) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"未配置该隐私使用说明" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [vc presentViewController:alert animated:YES completion:nil];
            } else if (status == CCAuthorizationStatusRestricted) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持此功能" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancel];
                [vc presentViewController:alert animated:YES completion:nil];
            } else if (status == CCAuthorizationStatusDenied) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->%@”选项中，允许%@访问您的%@", PrivacyNameMap[type], [NSBundle mainBundle].infoDictionary[@"CFBundleName"], PrivacyNameMap[type]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *setting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }];
                [alert addAction:cancel];
                [alert addAction:setting];
                [vc presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

// 查询通知权限
- (NSInteger)notificationAuthorizationStatus {
    NSLog(@"CCPrivacyManager：通知权限异步回调，请调用+ (void)requestAuthorizationForPrivacyType:(CCPrivacyType)type handler:(void(^_Nullable)(CCAuthorizationStatus status))handler");
    return 0;
}

// 请求获取通知权限
- (void)requestNotificationAuthorization:(void(^)(NSInteger status))handler {
    if (@available(iOS 10 , *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                handler(3);
            } else if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                handler(0);
            } else {
                handler(2);
            }
        }];
    } else if (@available(iOS 8 , *)) {
        UIUserNotificationSettings * settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (settings.types == UIUserNotificationTypeNone) {
            handler(2);
        } else {
            handler(3);
        }
    }
}

// 查询相机权限
- (NSInteger)cameraAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status;
}

// 请求获取相机权限
- (void)requestCamaraAuthorization:(void(^)(NSInteger status))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (handler) {
            if (granted) {
                handler(AVAuthorizationStatusAuthorized);
            } else {
                handler(AVAuthorizationStatusDenied);
            }
        }
    }];
}

// 查询相册权限
- (NSInteger)photoLibraryAuthorizationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status;
}

// 请求获取相册权限
- (void)requestPhotoLibraryAuthorization:(void(^)(NSInteger status))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (handler) {
            handler(status);
        }
    }];
}

// 查询通讯录权限
- (NSInteger)contactsAuthorizationStatus {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    return status;
}

// 请求获取通讯录权限
- (void)requestContactsAuthorization:(void(^)(NSInteger status))handler {
    [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (handler) {
            if (granted) {
                handler(CNAuthorizationStatusAuthorized);
            } else {
                handler(CNAuthorizationStatusDenied);
            }
        }
    }];
}

// 查询日历权限
- (NSInteger)calendarsAuthorizationStatus {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    return status;
}

// 请求获取日历权限
- (void)requestCalendarsAuthorization:(void(^)(NSInteger status))handler {
    [[[EKEventStore alloc] init] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (handler) {
            if (granted) {
                handler(EKAuthorizationStatusAuthorized);
            } else {
                handler(EKAuthorizationStatusDenied);
            }
        }
    }];
}

// 查询麦克风权限
- (NSInteger)microphoneAuthorizationStatus {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return status;
}

// 请求获取麦克风权限
- (void)requestMicrophoneAuthorization:(void(^)(NSInteger status))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (handler) {
            if (granted) {
                handler(AVAuthorizationStatusAuthorized);
            } else {
                handler(AVAuthorizationStatusDenied);
            }
        }
    }];
}

// 查询定位权限
- (NSInteger)locationAuthorizationStatus {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return status;
}

// 请求获取使用中定位权限
- (void)requestLocationWhenInUseAuthorization:(void(^)(NSInteger status))handler {
    [self.locationManager requestWhenInUseAuthorization];
}

// 请求获取始终定位权限
- (void)requestLocationAlwaysAuthorization:(void(^)(NSInteger status))handler {
    [self.locationManager requestAlwaysAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.handler) {
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            self.handler(CCAuthorizationStatusAuthorized);
        } else if (status == kCLAuthorizationStatusRestricted) {
            self.handler(CCAuthorizationStatusRestricted);
        } else if (status == kCLAuthorizationStatusDenied) {
            self.handler(CCAuthorizationStatusDenied);
        }
    }
}

@end
