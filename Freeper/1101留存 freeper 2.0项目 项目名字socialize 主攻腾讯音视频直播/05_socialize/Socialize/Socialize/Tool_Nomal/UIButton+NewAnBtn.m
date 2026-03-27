//
//  UIButton+NewAnBtn.m
//  Community
//
//  Created by 余莹 on 2021/1/29.
//

#import "UIButton+NewAnBtn.h"
#import "NSObject+Utils.h"
@implementation UIButton (NewAnBtn)
 
- (UIButton *)newAnBtnWithTextColor:(UIColor *)textColor
                      withBackColor:(UIColor *)backColor
                           withFont:(UIFont *)font
                 withLayerCorNerNum:(float)layerCorNer
                 withLayerLineWidth:(float)layerLineWidth
                 withLayerLineColor:(UIColor *)layerLineColor{
    if (self) {
        //
        WEAKSELF
        if (isNotNil(textColor)) {
            [self setTitleColor:textColor forState:UIControlStateNormal];
        }
        if (isNotNil(backColor)) {
            self.backgroundColor = backColor;
        }
        if (isNotNil(font)) {
            self.titleLabel.font = font;
        }
        //
        if (layerCorNer !=0 ) {
            self.layer.cornerRadius = layerCorNer;
        }
        if (layerLineWidth != 0) {
            self.layer.borderWidth = layerLineWidth;
        }
        if (isNotNil(layerLineColor)) {
            self.layer.borderColor = layerLineColor.CGColor;
        }
    }
   
    return self;
}

- (UIButton *)newAnBtnWithTextColorNomal:(UIColor *)textColorNomal
                   withTextColorSelected:(UIColor *)textColorNomalSelected
                          withFont:(UIFont *)font
                withLayerCorNerNum:(float)layerCorNer
                withLayerLineWidth:(float)layerLineWidth
                withLayerLineColor:(UIColor *)layerLineColor{
   if (self) {
       //
       if (isNotNil(textColorNomal)) {
           [self setTitleColor:textColorNomal forState:UIControlStateNormal];
       }
       if (isNotNil(textColorNomalSelected)) {
           [self setTitleColor:textColorNomalSelected forState:UIControlStateSelected];
       }
       if (isNotNil(font)) {
           self.titleLabel.font = font;
       }
       //
       if (layerCorNer !=0 ) {
           self.layer.cornerRadius = layerCorNer;
           self.layer.masksToBounds = YES;
       }
       if (layerLineWidth != 0) {
           self.layer.borderWidth = layerLineWidth;
       }
       if (isNotNil(layerLineColor)) {
           self.layer.borderColor = layerLineColor.CGColor;
       }
   }
  
   return self;
}
//
- (UIButton *)newAnBtnWithBackColor:(UIColor *)backColor{
    if (isNotNil(backColor)) {
        self.backgroundColor = backColor;
    }
    return self;
}
//_____
- (UIButton *)newAnBtnWithTextColor:(UIColor *)textColor{
    if (self) {
        if (isNotNil(textColor) && [textColor isKindOfClass:[UIColor class]]) {
            [self setTitleColor:textColor forState:UIControlStateNormal];
        }
    }
    return self;
}
- (UIButton *)newAnBtnWithTextColorNomal:(UIColor *)textColorNomal
                   withTextColorSelected:(UIColor *)textColorNomalSelected{
    if (self) {
        if (isNotNil(textColorNomal) && [textColorNomal isKindOfClass:[UIColor class]]) {
            [self setTitleColor:textColorNomal forState:UIControlStateNormal];
        }
        if (isNotNil(textColorNomalSelected) && [textColorNomalSelected isKindOfClass:[UIColor class]] ) {
            [self setTitleColor:textColorNomalSelected forState:UIControlStateSelected];
        }
    }
    return self;
}
//++++++++++
- (UIButton *)newAnBtnWithFont:(UIFont *)font{
    if (isNotNil(font) && [font isKindOfClass:[UIFont class]]) {
        self.titleLabel.font = font;
    }
    return self;
}
//_____
- (UIButton *)newAnBtnWithTextStr:(NSString *)str{
    if (self) {
        if ([str isKindOfClass:[NSString class]] && isNotNil(str) && str.length!=0) {
            [self setTitle:str forState:UIControlStateNormal];
        }
      
    }
    return self;
}
- (UIButton *)newAnBtnWithTextStrNomal:(NSString *)strNomal
                   withTextStrSelected:(NSString *)strSelected{
    if (self) {
        if ([strNomal isKindOfClass:[NSString class]] && isNotNil(strNomal) && strNomal.length!=0) {
            [self setTitle:strNomal forState:UIControlStateNormal];
        }
        if ([strSelected isKindOfClass:[NSString class]] && isNotNil(strSelected) && strSelected.length!=0) {
            [self setTitle:strSelected forState:UIControlStateSelected];
        }
    }
    return self;
}
//_____
- (UIButton *)newAnBtnWithImg:(UIImage *)img{
    if (isNotNil(img)) {
        [self setImage:img forState:UIControlStateNormal];
    }
    return self;
}
- (UIButton *)newAnBtnWithNomalImg:(UIImage *)nomalImg selectedImg:(UIImage *)selectedImg{
    if (isNotNil(nomalImg)) {
        [self setImage:nomalImg forState:UIControlStateNormal];
    }
    if (isNotNil(selectedImg)) {
        [self setImage:selectedImg forState:UIControlStateSelected];
    }
    return self;
}
//++++++++++
- (UIButton *)newAnBtnWithLayerCorNerNum:(float)layerCorNer
                      withLayerLineWidth:(float)layerLineWidth
                      withLayerLineColor:(UIColor *)layerLineColor{
    //
    if (layerCorNer !=0 ) {
        self.layer.cornerRadius = layerCorNer;
        self.layer.masksToBounds = YES;
    }
    if (layerLineWidth != 0) {
        self.layer.borderWidth = layerLineWidth;
    }
    if (isNotNil(layerLineColor) && layerLineWidth!=0) {
        self.layer.borderColor = layerLineColor.CGColor;
    }
    return self;
}

@end
