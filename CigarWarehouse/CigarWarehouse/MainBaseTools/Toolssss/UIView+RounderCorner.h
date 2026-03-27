//
//  UIView+RounderCorner.h
//  casgpLayerBezierPathCoreGraphics圆角
//
//  Created by 余莹 on 2021/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RounderCorner)
/**
 UIView的contents无内容可以直接通过设置cornerRadius达到效果。
 UILable的contents也一样，所以也可通过设置cornerRadius达到效果。不过label不能直接设置backgroundColor，因为这样设置的是contents的backgroundColor，需要设置layer. backgroundColor。

 作者：doudo
 链接：https://www.jianshu.com/p/e879aeff93f3
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */
/**
 前面提到过UIView通过cornerRadius就可以，但是如果特殊情况需要设置layer.masksToBounds，就不要通过cornerRadius方式了，会用到如下方式:*/
- (void)dlj_addRounderCornerWithRadius:(CGFloat)radius size:(CGSize)size;

- (void)dlj_addRounderCornerWithRadius:(CGFloat)radius corners:(UIRectCorner) corners;


@end

NS_ASSUME_NONNULL_END
