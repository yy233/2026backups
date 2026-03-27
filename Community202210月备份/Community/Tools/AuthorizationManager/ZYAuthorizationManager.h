//
//  ZYAuthorizationManager.h
//  Community
//
//  Created by ZY on 2021/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSystemPermissions) {
    KAVMediaTypeVideo = 0,  //相机
    KALAssetsLibrary,       //相册
    KCLLocationManager,     //地理位置信息
    KAVAudioSession,        //音频
    KABAddressBook          //手机通讯录
};

@interface ZYAuthorizationManager : NSObject
singleton_interface(sharedManager)

/**
 *  根据场景选择合适的提示系统权限类型
 *
 *  @param systemPermissions 系统权限类型
 *
 *  @param vc 显示提示框的vc
 *
 *  @return 是否具有权限
 */
- (BOOL)requestAuthorization:(KSystemPermissions)systemPermissions presentVc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
