//
//  UIButton+RefreshLocation.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (RefreshLocation)

/**
 *  图片在上边
 *  文字在下边
 */
- (void)refreshTopBottom;
/**
 *  图片在下边
 *  文字在上边
 */
- (void)refreshBottomTop;
/**
 *  图片在右边
 *  文字在左边
 */
- (void)refreshRightLeft;
/**
 *  已经用refresh刷新过不满意，可以调用此方法在原来基础上再次增加
 *
 *  @param top    上边
 *  @param bottom 下边
 *  @param left   左边
 *  @param right  右边
 */
- (void)refreshImageViewWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right;

- (void)refreshTitleLabelWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right;

//竖直排列 设置图片和文字的距离
- (void)verticalImageAndTitle:(CGFloat)spacing;
@end

NS_ASSUME_NONNULL_END
