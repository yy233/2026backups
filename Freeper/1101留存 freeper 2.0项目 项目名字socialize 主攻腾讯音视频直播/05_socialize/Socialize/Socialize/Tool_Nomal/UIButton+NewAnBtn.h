//
//  UIButton+NewAnBtn.h
//  Community
//
//  Created by 余莹 on 2021/1/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (NewAnBtn)
- (UIButton *)newAnBtnWithTextStr:(NSString *)str;
- (UIButton *)newAnBtnWithTextStrNomal:(NSString *)strNomal
                   withTextStrSelected:(NSString *)strSelected; 
//
- (UIButton *)newAnBtnWithTextColor:(UIColor *)textColor;
- (UIButton *)newAnBtnWithTextColorNomal:(UIColor *)textColorNomal
                   withTextColorSelected:(UIColor *)textColorNomalSelected;
//
- (UIButton *)newAnBtnWithTextColor:(nullable UIColor *)textColor
                      withBackColor:(nullable UIColor *)backColor
                           withFont:(nullable UIFont *)font
                 withLayerCorNerNum:(float)layerCorNer
                 withLayerLineWidth:(float)layerLineWidth
                 withLayerLineColor:(nullable UIColor *)layerLineColor;
//
- (UIButton *)newAnBtnWithTextColorNomal:(UIColor *)textColorNomal
                   withTextColorSelected:(UIColor *)textColorNomalSelected
                          withFont:(UIFont *)font
                withLayerCorNerNum:(float)layerCorNer
                withLayerLineWidth:(float)layerLineWidth
                      withLayerLineColor:(UIColor *)layerLineColor;

- (UIButton *)newAnBtnWithImg:(UIImage *)img;
- (UIButton *)newAnBtnWithNomalImg:(UIImage *)nomalImg selectedImg:(UIImage *)selectedImg;

//
- (UIButton *)newAnBtnWithLayerCorNerNum:(float)layerCorNer
                      withLayerLineWidth:(float)layerLineWidth
                      withLayerLineColor:(UIColor *)layerLineColor;
- (UIButton *)newAnBtnWithFont:(UIFont *)font;
//
- (UIButton *)newAnBtnWithBackColor:(UIColor *)backColor;


@end

NS_ASSUME_NONNULL_END
