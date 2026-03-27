//
//  ZhuBoInfoBottomItemView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/23.
//

#import "ZhuBoInfoBottomItemView.h"

@implementation ZhuBoInfoBottomItemView

- (instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, Screen_W, 200);
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = rgba(0, 0, 0, 1);
        [self addSubview:self.callATMeBtn];
        [self addSubview:self.siXinBtn];
        [self addSubview:self.guanZhuBtn];
        [self setsubViews];
    }
    return self;
 
}
- (void)setsubViews{

    [_callATMeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_callATMeBtn.superview).offset(16);
        make.height.offset(36);
        make.width.offset(76);
        make.centerY.equalTo(_callATMeBtn.superview);
    }];
    
    [_siXinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_callATMeBtn.mas_right).offset(10);
        make.height.offset(36);
        make.width.offset(76);
        make.centerY.equalTo(_siXinBtn.superview);
    }];
    
    [_guanZhuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_siXinBtn.mas_right).offset(10);
        make.right.equalTo(_guanZhuBtn.superview.mas_right).offset(-16);
        make.height.offset(36);
        make.centerY.equalTo(_guanZhuBtn.superview);
    }];
    
}

- (UIButton *)callATMeBtn{
    if(!_callATMeBtn){
        _callATMeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callATMeBtn newAnBtnWithBackColor:[UIColor clearColor]];
        [_callATMeBtn newAnBtnWithLayerCorNerNum:16 withLayerLineWidth:1.0 withLayerLineColor: [UIColor whiteColor]];
        [_callATMeBtn newAnBtnWithTextStr:@"@me"];
        [_callATMeBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_callATMeBtn addTarget:self action:@selector(callATMeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callATMeBtn;
}

- (UIButton *)siXinBtn{
    if(!_siXinBtn){
        _siXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_siXinBtn newAnBtnWithBackColor:[UIColor clearColor]];
        [_siXinBtn newAnBtnWithLayerCorNerNum:16 withLayerLineWidth:1.0 withLayerLineColor: [UIColor whiteColor]];
        [_siXinBtn newAnBtnWithTextStr:@"私信"];
        [_siXinBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_siXinBtn addTarget:self action:@selector(sixinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _siXinBtn;
}
- (UIButton *)guanZhuBtn{
    if(!_guanZhuBtn){
        _guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_guanZhuBtn newAnBtnWithBackColor:rgba(102, 208, 209, 1)];
        [_guanZhuBtn newAnBtnWithLayerCorNerNum:16 withLayerLineWidth:0.0 withLayerLineColor: [UIColor whiteColor]];
        [_guanZhuBtn newAnBtnWithTextStr:@"关注"];
        [_guanZhuBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_guanZhuBtn addTarget:self action:@selector(guanZhuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _guanZhuBtn;
}

#pragma mark===
- (void)callATMeBtnAction{
    if(_delegate && [_delegate respondsToSelector:@selector(touchAtMe)]){
        [_delegate touchAtMe];
    }
}
- (void)sixinBtnAction{
    if(_delegate && [_delegate respondsToSelector:@selector(touchSiXin)]){
        [_delegate touchSiXin];
    }
}
- (void)guanZhuBtnAction{
    if(_delegate && [_delegate respondsToSelector:@selector(touchGuanZhu)]){
        [_delegate touchGuanZhu];
    }
}


@end
