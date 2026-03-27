//
//  ImgSetSize.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgSetSize : UIView
+ (UIImage*)setimageSize:(UIImage *)inImage
                   width:(CGFloat)width
                  height:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
