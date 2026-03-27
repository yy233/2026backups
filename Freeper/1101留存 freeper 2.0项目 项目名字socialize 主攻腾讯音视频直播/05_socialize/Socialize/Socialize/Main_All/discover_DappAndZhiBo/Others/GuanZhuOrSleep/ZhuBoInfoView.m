//
//  ZhuBoInfoView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import "ZhuBoInfoView.h"

@implementation ZhuBoInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = rgba(0, 0, 0, 1);
        [self addSubview:self.topBkImgV];
        [self addSubview:self.bottomBkView];
        [self addSubview:self.imgV];
        [self.bottomBkView addSubview:self.idLable];
        [self.bottomBkView addSubview:self.rightTopJuBaoBtn];
        [self.bottomBkView addSubview:self.nickNameL];
        [self.bottomBkView addSubview:self.baseInfoBkView];
        [self.bottomBkView addSubview:self.infoTextView];
        [self setsubViews];
    }
    return self;
 
}


- (UIImageView *)topBkImgV{
    if(!_topBkImgV){
        _topBkImgV = [[UIImageView alloc]init];
        _topBkImgV.backgroundColor = [UIColor lightGrayColor];
    }
    return _topBkImgV;
}
- (UIImageView *)imgV{
    if(!_imgV){
        _imgV = [[UIImageView alloc]init];
        _imgV.backgroundColor = [UIColor cyanColor];
    }
    return _imgV;
}
- (UIView *)bottomBkView{
    if(!_bottomBkView){
        _bottomBkView = [[UIView alloc]init];
    }
    return _bottomBkView;
}
- (UILabel *)idLable{
    if(!_idLable){
        _idLable = [[UILabel alloc]init];
        _idLable.textColor = [UIColor whiteColor];
        _idLable.text = @"";
        _idLable.font = [UIFont boldSystemFontOfSize:22];
        _idLable.textAlignment = NSTextAlignmentLeft;
    }
    return _idLable;
}
- (UIButton *)rightTopJuBaoBtn{
    if(!_rightTopJuBaoBtn){
        _rightTopJuBaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightTopJuBaoBtn newAnBtnWithBackColor:rgba(102, 208, 209, 1)];
        [_rightTopJuBaoBtn newAnBtnWithLayerCorNerNum:16 withLayerLineWidth:0.0 withLayerLineColor:[UIColor whiteColor]];
        [_rightTopJuBaoBtn newAnBtnWithImg:[UIImage imageNamed:@"wColorShuDian"]];
        [_rightTopJuBaoBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_rightTopJuBaoBtn addTarget:self action:@selector(touchRightJuBaoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTopJuBaoBtn;
}

- (UILabel *)nickNameL{
    if(!_nickNameL){
        _nickNameL = [[UILabel alloc]init];
        _nickNameL.textColor = [UIColor whiteColor];
        _nickNameL.text = @"";
        _nickNameL.font = [UIFont boldSystemFontOfSize:22];
        _nickNameL.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameL;
}
- (UIView *)baseInfoBkView{
    if(!_baseInfoBkView){
        _baseInfoBkView = [[UIView alloc]init];
    }
    return _baseInfoBkView;
}


- (UITextView *)infoTextView{
    if(!_infoTextView){
        _infoTextView = [[UITextView alloc]init];
        _infoTextView.backgroundColor = [UIColor clearColor];
        _infoTextView.text = @"infoTextViewinfoTextViewinfoTextViewinfoTextViewinfoTextView11111";
        _infoTextView.textColor = rgba(193, 192, 201, 1);
        _infoTextView.font = [UIFont systemFontOfSize:15.0];
        _infoTextView.userInteractionEnabled = NO;
    }
    return _infoTextView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    _imgV.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, 100, 100) withCornerRadi:CGSizeMake(50, 50) withRoundingCorners:UIRectCornerAllCorners];
    
    _bottomBkView.layer.mask = [BezierPathTool bezierPathToolWithThisViewBounds:CGRectMake(0, 0, Screen_W, Screen_H/2-200) withCornerRadi:CGSizeMake(10, 10) withRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
}


#pragma mark ===
- (void)setsubViews{
    
    [_topBkImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_topBkImgV.superview);
        make.height.equalTo(_topBkImgV.superview).multipliedBy(0.45);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(100);
        make.centerX.equalTo(_imgV.superview);
        make.bottom.equalTo(_topBkImgV.mas_bottom).offset(50);
    }];
    //
    [_bottomBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomBkView.superview);
        make.top.equalTo(_topBkImgV.mas_bottom);
    }];
    [_idLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgV.mas_left);
        make.left.equalTo(_idLable.superview).offset(16);
        make.height.offset(20);
        make.centerY.equalTo(_imgV).offset(40);
    }];
    [_rightTopJuBaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.centerY.equalTo(_imgV).offset(40);;
        make.right.equalTo(_rightTopJuBaoBtn.superview).offset(-30);
    }];
    
    //
    [_nickNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_nickNameL.superview).multipliedBy(0.8);
        make.centerX.equalTo(_nickNameL.superview);
        make.height.offset(30);
        make.top.equalTo(_imgV.mas_bottom).offset(16);
    }];
    [_baseInfoBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_baseInfoBkView.superview).multipliedBy(0.7);
        make.centerX.equalTo(_baseInfoBkView.superview);
        make.height.offset(60);
        make.top.equalTo(_nickNameL.mas_bottom).offset(10);
    }];
    [_infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_baseInfoBkView.superview).multipliedBy(0.8);
        make.centerX.equalTo(_baseInfoBkView.superview);
        make.top.equalTo(_baseInfoBkView.mas_bottom).offset(10);
        make.bottom.equalTo(_infoTextView.superview.mas_bottom).offset(0);
    }];
}

- (void)touchRightJuBaoBtnAction{
    DLog();
}

 
@end
