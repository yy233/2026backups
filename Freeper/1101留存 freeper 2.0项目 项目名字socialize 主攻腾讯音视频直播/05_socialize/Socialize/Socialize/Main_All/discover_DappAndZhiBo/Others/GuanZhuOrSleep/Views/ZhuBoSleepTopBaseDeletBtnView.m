//
//  TopBaseDeletBtnView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "ZhuBoSleepTopBaseDeletBtnView.h"

 
@implementation ZhuBoSleepTopBaseDeletBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = rgba(0, 0, 0, 1);
        [self addSubview:self.bakImg];
        [self addSubview:self.rightTopBtn];
        [self addSubview:self.imgV];
        [self addSubview:self.topL];
        [self addSubview:self.botL];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self setsubViews];
    }
    return self;
}

 

- (void)setsubViews{
    [self.bakImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bakImg.superview);
    }];
    
    [_rightTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightBtn.superview).offset(90);
        make.right.equalTo(_rightBtn.superview).offset(-16);
        make.width.height.offset(30.0);
    }];
    
    [_topL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_topL.superview).offset(-32);
        make.right.equalTo(_topL.superview).offset(-16);
        make.top.equalTo(_rightTopBtn.mas_bottom);
        make.height.offset(30);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(100);
        make.centerX.equalTo(_imgV.superview);
        make.top.equalTo(_topL.mas_bottom).offset(24);
    }];
    [_botL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_topL);
        make.top.equalTo(_imgV.mas_bottom).offset(24);
        make.height.offset(30);
    }];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_botL.mas_bottom).offset(30);
        make.width.offset(124);
        make.height.offset(36);
        make.right.equalTo(_leftBtn.superview.mas_centerX).offset(-5);
    }];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_botL.mas_bottom).offset(30);
        make.width.offset(124);
        make.height.offset(36);
        make.left.equalTo(_rightBtn.superview.mas_centerX).offset(5);
    }];
}

- (UIImageView *)bakImg{
    if(!_bakImg){
        _bakImg = [[UIImageView alloc]init];
    }
    return _bakImg;
}
- (UIButton *)rightTopBtn{
    if(!_rightTopBtn){
        _rightTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightTopBtn newAnBtnWithImg:[UIImage imageNamed:@"btn_close"]];
        [_rightTopBtn addTarget:self action:@selector(touchDeletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTopBtn;
}
- (UIImageView *)imgV{
    if(!_imgV){
        _imgV = [[UIImageView alloc]init];
        _imgV.backgroundColor = [UIColor lightGrayColor];
    }
    return _imgV;
}
- (UILabel *)topL{
    if(!_topL){
        _topL = [[UILabel alloc]init];
        _topL.textColor = [UIColor whiteColor];
        _topL.text = @"主播休息中...";
        _topL.font = [UIFont boldSystemFontOfSize:22];
        _topL.textAlignment = NSTextAlignmentCenter;
    }
    return _topL;
}
- (UILabel *)botL{
    if(!_botL){
        _botL = [[UILabel alloc]init];
        _botL.textColor = [UIColor whiteColor];
        _botL.text = @"";
        _botL.font = [UIFont boldSystemFontOfSize:22];
        _botL.textAlignment = NSTextAlignmentCenter;
    }
    return _botL;
}
- (UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn newAnBtnWithBackColor:rgba(102, 208, 209, 1)];
        [_leftBtn newAnBtnWithLayerCorNerNum:16 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
        [_leftBtn newAnBtnWithTextStr:@"回到首页"];
        [_leftBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_leftBtn addTarget:self action:@selector(touchRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn newAnBtnWithBackColor:[UIColor clearColor]];
        [_rightBtn newAnBtnWithLayerCorNerNum:16 withLayerLineWidth:1.0 withLayerLineColor:rgba(102, 208, 209, 1)];
        [_rightBtn newAnBtnWithTextStr:@"开播提醒"];
        [_rightBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_rightBtn addTarget:self action:@selector(touchLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imgV.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, 100, 100) withCornerRadi:CGSizeMake(50, 50) withRoundingCorners:UIRectCornerAllCorners];
    //[_imgV zy_cornerRadiusRoundingRect];
}


#pragma mark===
- (void)touchDeletBtnAction{
    
    if(_delegate && [_delegate respondsToSelector:@selector(touchDeletBtn)]){
        [_delegate touchDeletBtn];
    }
}

- (void)touchRightBtnAction{
    
    if(_delegate && [_delegate respondsToSelector:@selector(touchGoMainVc)]){
        [_delegate touchGoMainVc];
    }
}

- (void)touchLeftBtnAction{
    
    if(_delegate && [_delegate respondsToSelector:@selector(touchKaiBoTiXing)]){
        [_delegate touchKaiBoTiXing];
    }
}
@end
