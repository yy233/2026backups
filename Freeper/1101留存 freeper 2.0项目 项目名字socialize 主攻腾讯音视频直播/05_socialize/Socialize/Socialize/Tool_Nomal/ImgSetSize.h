//
//  ImgSetSize.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgSetSize : UIView
//纯色的可以
+ (UIImage*)setimageSize:(UIImage *)inImage
                   width:(CGFloat)width
                  height:(CGFloat)height;

//图片的img size更改
+ (UIImage*)changeImageSizeWithImg:(UIImage *)oldImage scaleToSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END
