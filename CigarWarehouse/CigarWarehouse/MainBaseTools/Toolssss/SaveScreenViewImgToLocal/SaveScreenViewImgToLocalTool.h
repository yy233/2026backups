//
//  SaveScreenViewImgToLocalTool.h
//  Community
//
//  Created by 余莹 on 2021/10/27.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
NS_ASSUME_NONNULL_BEGIN

@interface SaveScreenViewImgToLocalTool : NSObject
//图片转img
+ (UIImage *)captureImageFromView:(UIView *)view;
#pragma mark === //截图保存功能
//
+ (void)saveImgToPhonePhotoLocalWithImg:(UIImage *)img;
//
+ (void)saveImgToPhonePhotoLocalWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
