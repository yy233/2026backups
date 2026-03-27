//
//  ManagerHeader.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#ifndef ManagerHeader_h
#define ManagerHeader_h

#ifdef __OBJC__
#import "IsLoginTool.h" //登录类型存储
#import "ThemeManager.h"//主题


//swift蓝牙手环

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBPeripheral.h>

#import "TrusangBluetooth.framework/Headers/ZHJBLETools.h"
#import <TrusangBluetooth/TrusangBluetooth.h>
#import <TrusangBluetooth/TrusangBluetooth-Swift.h>
#import "TrusangBluetooth.framework/Headers/TrusangBluetooth.h"
#import "TrusangBluetooth.framework/Headers/TrusangBluetooth-Swift.h"

#import "TrusangBlueToothSdkDataManager.h" //蓝牙手环

#import "PensionThemeManager.h"//养老
#import "MedicalCareThemeManager.h"//医疗
//
#import "ZYThemeManager.h"
#import "ThemeImg.h"
#define  NOTICE_NAME_ThemeISChanged @"themeIsChange"
#import "NativePositioningManager.h"//原生定位
#import "ZYPositioningManager.h"

//
#define Key_SaveThemeTypeWithStr  @"SaveThemeTypeStr"

 
 
//当前小区的权限列表和最高权限相关信息管理
#import "UserNowCommitRightManager.h"

#pragma mark ==== manager
#import "PayTool.h"

#import "WechatLoginManager.h"
#import "ZFBLoginManager.h"
#import "QQLoginManager.h"
#import "AppleLoginManager.h"

#import "PayBaseInfo.h"
#import "WeChatPayManager.h"
#import "ZfbPayManager.h"
#import "WeChatPayData.h"

#pragma mark ==== 极光
#define JiGuang_RegId          [JGSaveIdShare sharedUserInfo].registrationID// @"xxxxxxxxxxx"
#pragma mark ====

static  NSString *JG_Appkey = @"49e3800dded63dd9fce68b16";
static  NSString *JG_Secret = @"c18019c1c0a346b61c2c9e60";

#pragma mark ==== appid
#define WX_APP_ID               @"wxe84d22f50370bbda"
#define WX_UNIVERSAL_LINK       @"https://www.zhsj.co/"
//#define WX_APP_SECRET            @""


//#define ZFB_APP_ID             @"2021002110645689"
#define ZFB_APP_ID              @"2021002119679359"  //暂不用这个宏。该用什么接口获取

#define QQ_APP_ID @""
 


#endif
#endif /* ManagerHeader_h */
