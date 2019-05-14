//
//  CCPrivacyManager.h
//
//  Copyright © 2019 侯文富. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 功能类型
typedef NS_ENUM(NSInteger, CCPrivacyType) {
    CCPrivacyTypeNotification,          // push通知权限
    CCPrivacyTypeCamera,                // 相机权限
    CCPrivacyTypePhotoLibrary,          // 相册权限（非拉取数据不需权限）
    CCPrivacyTypeContacts,              // 通讯录权限（非拉取数据不需权限）
    CCPrivacyTypeCalendars,             // 日历权限
    CCPrivacyTypeMicrophone,            // 麦克风权限
    CCPrivacyTypeLocationWhenInUse,     // 定位权限（使用中访问）
    CCPrivacyTypeLocationAlways,        // 定位权限（始终访问）
//    CCPrivacyTypeLocationUsage,         // 位置权限
//    CCPrivacyTypeBluetoothPeripheral,   // 蓝牙权限
//    CCPrivacyTypeSpeechRecognition,     // 语音转文字权限
//    CCPrivacyTypeMediaLibrary,          // 媒体库权限
//    CCPrivacyTypeHealthShare,           // 健康分享权限
//    CCPrivacyTypeHealthUpdate,          // 健康更新权限
//    CCPrivacyTypeMotion,                // 运动使用权限
//    CCPrivacyTypeMusic,                 // 音乐权限
//    CCPrivacyTypeReminders,             // 提醒使用权限
//    CCPrivacyTypeSiri,                  // Siri使用权限
//    CCPrivacyTypeTVProvider,            // 电视供应商使用权限
//    CCPrivacyTypeVideoSubscriberAccount,// 视频用户账号使用权限
};

/// 表示客户端对用户相关功能的底层硬件的授权的常量。
typedef NS_ENUM(NSInteger, CCAuthorizationStatus) {
    CCAuthorizationStatusNotInfoPlist  = -1,    // 客户端未在Info.plist里注册相关功能的使用说明。
    CCAuthorizationStatusNotDetermined = 0,     // 表示用户尚未选择客户端是否可以访问相关功能的硬件。
    CCAuthorizationStatusRestricted    = 1,     // 客户端无权访问相关功能硬件。用户无法更改客户端的状态，这可能是由于父母控制等主动限制所致。
    CCAuthorizationStatusDenied        = 2,     // 用户明确拒绝访问支持客户端相关功能的硬件。
    CCAuthorizationStatusAuthorized    = 3,     // 客户端被授权访问支持相关功能的硬件。
};

@interface CCPrivacyManager : NSObject

/// 返回客户端的授权状态，以访问支持给定功能类型的底层硬件。
+ (CCAuthorizationStatus)authorizationStatusForPrivacyType:(CCPrivacyType)type;

/// 请求隐私权限
+ (void)requestAuthorizationForPrivacyType:(CCPrivacyType)type handler:(void(^_Nullable)(CCAuthorizationStatus status))handler;

/// 请求隐私权限，如果vc不为空，权限不足则提示alert
+ (void)requestAuthorizationForPrivacyType:(CCPrivacyType)type fromVC:(UIViewController *_Nullable)vc handler:(void(^_Nullable)(CCAuthorizationStatus status))handler;

@end

