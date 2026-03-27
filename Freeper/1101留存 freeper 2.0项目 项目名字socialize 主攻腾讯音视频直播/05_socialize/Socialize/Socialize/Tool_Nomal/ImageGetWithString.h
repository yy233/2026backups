//
//  ImageGetWithString.h
//  Community
//
//  Created by 余莹 on 2020/12/18.
//// 根据urlstr获取图片

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ImageGetWithString : NSObject
+ (UIImage *)getImageFromURLStr:(NSString *)urlStr;
@end

NS_ASSUME_NONNULL_END
