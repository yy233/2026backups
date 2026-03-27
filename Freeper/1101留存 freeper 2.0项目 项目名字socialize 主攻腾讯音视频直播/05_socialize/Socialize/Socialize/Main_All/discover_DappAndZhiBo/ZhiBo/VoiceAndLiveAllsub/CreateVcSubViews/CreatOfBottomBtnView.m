//
//  CreatOfBottomBtnView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/23.
//

#import "CreatOfBottomBtnView.h"

@implementation CreatOfBottomBtnView


- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
   if(self){
       [self addSubview:self.footerB];
       [self setsubViews];
   }
   return self;
}
- (void)setsubViews{
    [_footerB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_footerB.superview).offset(-60);
        make.centerY.centerX.equalTo(_footerB.superview);
        make.height.offset(50);
    }];
}
- (UIButton *)footerB{
    if(!_footerB){
        _footerB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerB newAnBtnWithLayerCorNerNum:24.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_footerB newAnBtnWithBackColor:rgba(102, 208, 209, 1)];
    }
    return _footerB;
}
@end
