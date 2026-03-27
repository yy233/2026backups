//
//  QRCodeImageColor.h
//  RobotLeo
//
//  Created by 齐 浩 on 15/7/28.
//  Copyright (c) 2015年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeImageColor : NSObject
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
- (CIImage *)createQRForString:(NSString *)qrString;
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;
@end
