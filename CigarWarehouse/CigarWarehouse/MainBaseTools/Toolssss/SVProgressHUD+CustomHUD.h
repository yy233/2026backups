//
//  SVProgressHUD+CustomHUD.h
//  Community
//
//  Created by ZY on 2021/5/18.
//

#import "SVProgressHUD.h"

typedef enum : NSUInteger {
    ProgressHUD_Type_Success,   // 成功
    ProgressHUD_Type_Error,     // 失败
    ProgressHUD_Type_Loading,   // 加载
    ProgressHUD_Type_Info       // 信息
} ProgressHUD_Type;

NS_ASSUME_NONNULL_BEGIN

@interface SVProgressHUD (CustomHUD)

// 加载提示
+ (void)showLoadingCustomHUDWithStatus:(NSString *)status;

// 加载提示
+ (void)showLoadingMaskTypeCustomHUDWithStatus:(NSString *)status;

// 成功提示
+ (void)showSuccessCustomHUDWithStatus:(NSString *)status;

// 失败提示
+ (void)showErrorCustomHUDWithStatus:(NSString *)status;

// 失败提示，设置显示时间
+ (void)showErrorCustomHUDWithStatus:(NSString *)status delay:(NSTimeInterval)delay;

// 信息提示
+ (void)showInfoCustomHUDWithStatus:(NSString *)status;

// 定制提示
+ (void)showCustomHUDWithStatus:(NSString *)status progressHUDType:(ProgressHUD_Type)progressHUD_Type maskType:(SVProgressHUDMaskType)progressHUDMaskType;

// 重置提示设置
+ (void)resetDefaultHUD;

@end

NS_ASSUME_NONNULL_END
