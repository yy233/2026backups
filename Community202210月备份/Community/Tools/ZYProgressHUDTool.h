//
//  ZYProgressHUDTool.h
//  Community
//
//  Created by ZY on 2021/7/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYProgressHUDTool : NSObject

+ (void)showCustomHUDTextMessage:(NSString *)msg toView:(UIView *)view;

+ (void)showCustomHUDTextNoUserInteractionMessage:(NSString *)msg toView:(UIView *)view;

+ (void)showCustomHUDTextMessage:(NSString *)msg toView:(UIView *)view delay:(NSTimeInterval)delay;

+ (void)showCustomHUDMessage:(NSString *)msg toView:(UIView *)view delay:(NSTimeInterval)delay mode:(MBProgressHUDMode)mode;

+ (void)showCustomHUDNoUserInteractionMessage:(NSString *)msg toView:(UIView *)view delay:(NSTimeInterval)delay mode:(MBProgressHUDMode)mode;

@end

NS_ASSUME_NONNULL_END
