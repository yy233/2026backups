//
//  SVProgressHUD+CustomHUD.m
//  Community
//
//  Created by ZY on 2021/5/18.
//

#import "SVProgressHUD+CustomHUD.h"

@implementation SVProgressHUD (CustomHUD)

+ (void)showLoadingCustomHUDWithStatus:(NSString *)status {
    
    [self baseSetHUD];
    [self showWithStatus:status];
}

+ (void)showLoadingMaskTypeCustomHUDWithStatus:(NSString *)status {
    
    [self baseSetHUD];
    [self showWithStatus:status];
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

+ (void)showSuccessCustomHUDWithStatus:(NSString *)status {
    
    [self baseSetHUD];
    [self setImageViewSize:CGSizeMake(24, 24)];
    [self showSuccessWithStatus:status];
    [self dismissWithDelay:2.0];
}

+ (void)showErrorCustomHUDWithStatus:(NSString *)status {
    
    [self baseSetHUD];
    [self setImageViewSize:CGSizeMake(20, 20)];
    [self showErrorWithStatus:status];
    [self dismissWithDelay:2.0];
}

+ (void)showErrorCustomHUDWithStatus:(NSString *)status delay:(NSTimeInterval)delay {
    
    [self baseSetHUD];
    [self setImageViewSize:CGSizeMake(20, 20)];
    [self showErrorWithStatus:status];
    [self dismissWithDelay:delay];
}

+ (void)showInfoCustomHUDWithStatus:(NSString *)status {
    
    [self baseSetHUD];
    [self setImageViewSize:CGSizeMake(30, 30)];
    [self showInfoWithStatus:status];
    [self dismissWithDelay:2.0];
}

+ (void)showCustomHUDWithStatus:(NSString *)status progressHUDType:(ProgressHUD_Type)progressHUD_Type maskType:(SVProgressHUDMaskType)progressHUDMaskType {
    
    [self baseSetHUD];
    if (progressHUD_Type == ProgressHUD_Type_Info) {
        [self setImageViewSize:CGSizeMake(30, 30)];
        [self showInfoWithStatus:status];
    }else if (progressHUD_Type == ProgressHUD_Type_Loading) {
        [self showWithStatus:status];
    }else if (progressHUD_Type == ProgressHUD_Type_Success) {
        [self setImageViewSize:CGSizeMake(24, 24)];
        [self showSuccessWithStatus:status];
    }else if (progressHUD_Type == ProgressHUD_Type_Error) {
        [self setImageViewSize:CGSizeMake(20, 20)];
        [self showErrorWithStatus:status];
    }
    [self setDefaultMaskType:progressHUDMaskType];
}

+ (void)resetDefaultHUD {
    
    [self baseSetHUD];
    [self setImageViewSize:CGSizeMake(24, 24)];
}

+ (void)baseSetHUD {
    
    [self setDefaultStyle:SVProgressHUDStyleCustom];
    [self setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self dismissWithDelay:20.0];
    [self setForegroundColor:[UIColor blackColor]];
    [self setBackgroundColor:Y_RGBA(245, 245, 245, 1)];
    [self setFont:[UIFont systemFontOfSize:16]];
    [self setMinimumSize:CGSizeMake(120, 120)];
    [self setRingRadius:20];
}

@end
