//
//  IMUserInfoHeaderImg.m
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import "IMUserInfoHeaderImg.h"

@implementation IMUserInfoHeaderImg
 


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.nameL];
        [self addSubview:self.addressBtn];
        [self addSubview:self.callSiXinBtn];
        [self setUIs];
        
    }
    return self;
}
- (void)setUIs{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(62.0);
        make.left.equalTo(_imgView.superview).offset(20);
        make.centerY.equalTo(_imgView.superview);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgView.mas_right).offset(20);
        make.top.equalTo(_imgView);
        make.width.equalTo(_nameL.superview).offset(-220);
    }];
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameL);
        make.right.equalTo(_nameL);
        make.height.offset(20);
        make.top.equalTo(_nameL.mas_bottom);
    }];
    [_callSiXinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(36);
        make.width.offset(100);
        make.right.equalTo(_callSiXinBtn.superview).offset(-20);
        make.bottom.equalTo(_imgView);
    }];
}

- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 62, 62)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.layer.cornerRadius = 6;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}
- (UILabel *)nameL{
    if(!_nameL){
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = rgba(51, 51, 51, 1);
        _nameL.font = [UIFont systemFontOfSize:16.0];
    }
    return _nameL;
}

- (UIButton *)addressBtn{
    if(!_addressBtn){
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
        [_addressBtn newAnBtnWithTextColor:rgba(153, 153, 153, 1)];
//        [_addressBtn newAnBtnWithImg:[UIImage imageNamed:@""]]
    }
    return _addressBtn;
}

- (UIButton *)callSiXinBtn{
    if(!_callSiXinBtn){
        _callSiXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callSiXinBtn newAnBtnWithBackColor:rgba(61, 240, 240, 1)];
        [_callSiXinBtn newAnBtnWithImg:[UIImage imageNamed:@"私信"]];
        [_callSiXinBtn newAnBtnWithFont:[UIFont systemFontOfSize:16.0]];
        [_callSiXinBtn newAnBtnWithTextColor:rgba(51, 51, 51, 1)];
        [_callSiXinBtn newAnBtnWithTextStr:@"私信"];
        [_callSiXinBtn newAnBtnWithLayerCorNerNum:17.0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _callSiXinBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //[self.imgView zy_cornerRadiusAdvance:6.0 rectCornerType:UIRectCornerAllCorners];
    
}
@end
