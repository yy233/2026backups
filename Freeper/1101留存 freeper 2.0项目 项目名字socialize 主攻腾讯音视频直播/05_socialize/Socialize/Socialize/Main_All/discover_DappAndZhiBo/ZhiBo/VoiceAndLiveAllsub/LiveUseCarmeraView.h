//
//  LiveUseCarmeraView.h
//  Socialize
//
//  Created by 余莹 on 2023/8/4.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface LiveUseCarmeraView : UIView
/**
 初始化摄像头 - 参数
 devicePosition:设置前后摄像头
 viedoOrientation:设置是竖屏相机还是横屏相机
 */
- (void)setupCameraWithPosition:(AVCaptureDevicePosition)devicePosition onVideoOrientation:(AVCaptureVideoOrientation)viedoOrientation;
 
@end

NS_ASSUME_NONNULL_END
