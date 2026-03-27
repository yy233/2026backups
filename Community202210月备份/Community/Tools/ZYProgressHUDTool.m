//
//  ZYProgressHUDTool.m
//  Community
//
//  Created by ZY on 2021/7/26.
//

#import "ZYProgressHUDTool.h"

@implementation ZYProgressHUDTool

+ (void)showCustomHUDTextMessage:(NSString *)msg toView:(UIView *)view {
    
    MBProgressHUD *hud = [self showHUDMessage:msg toView:view];
    [hud hide:YES afterDelay:2.0];
}

+ (void)showCustomHUDTextNoUserInteractionMessage:(NSString *)msg toView:(UIView *)view {
    
    MBProgressHUD *hud = [self showHUDMessage:msg toView:view];
    hud.userInteractionEnabled = YES;
    [hud hide:YES afterDelay:2.0];
}

+ (void)showCustomHUDTextMessage:(NSString *)msg toView:(UIView *)view delay:(NSTimeInterval)delay {
    
    MBProgressHUD *hud = [self showHUDMessage:msg toView:view];
    [hud hide:YES afterDelay:delay];
}

+ (void)showCustomHUDMessage:(NSString *)msg toView:(UIView *)view delay:(NSTimeInterval)delay mode:(MBProgressHUDMode)mode {
    
    MBProgressHUD *hud = [self showHUDMessage:msg toView:view];
    hud.mode = mode;
    [hud hide:YES afterDelay:delay];
}

+ (void)showCustomHUDNoUserInteractionMessage:(NSString *)msg toView:(UIView *)view delay:(NSTimeInterval)delay mode:(MBProgressHUDMode)mode {
    
    MBProgressHUD *hud = [self showHUDMessage:msg toView:view];
    hud.userInteractionEnabled = YES;
    hud.mode = mode;
    [hud hide:YES afterDelay:delay];
}

+ (MBProgressHUD *)showHUDMessage:(NSString *)msg toView:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:msg toView:view];
    hud.userInteractionEnabled = NO;
    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeText;
    hud.color = Y_RGBA(235, 235, 235, 1);
    hud.labelColor = Y_RGBA(51, 51, 51, 1);
    CGFloat differenceValue = kScreenH - (view.bounds.size.height + 44 + status_height);
    if (differenceValue > -10 && differenceValue < 10) {
        hud.yOffset = -(44 + status_height) / 2;
    }
    
    return hud;
}

@end
