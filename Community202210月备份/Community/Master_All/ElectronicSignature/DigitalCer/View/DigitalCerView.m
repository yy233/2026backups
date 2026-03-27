//
//  DigitalCerView.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "DigitalCerView.h"

@implementation DigitalCerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.oneBtn];
        [self addSubview:self.twoBtn];
        [self setNewViewUI];
        [self setOldViewProperty];
         
    }
    return self;
}
- (void)setNewViewUI{
    //
    [self.titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerImgV.mas_bottom).offset(0);
    }];
    [self.detailL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleL.mas_bottom).offset(50);
    }];
    //
    [_oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailL);
        make.top.equalTo(self.detailL.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    [_twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_oneBtn);
        make.top.equalTo(_oneBtn.mas_bottom).offset(5);
        make.height.offset(30);
    }];
    //
    [self.goToAuthenticatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_twoBtn.mas_bottom).offset(50);
    }];
}
- (void)setOldViewProperty{
 
    self.centerImgV.image = [UIImage imageNamed:@"az"];
    //
    self.titleL.text = @"请安装数字证书";
    self.titleL.textColor = Y_RGBA(136, 136, 136, 1);
    self.titleL.font = FontSize_ElectronicSignature_Nomail(16);
    self.titleL.textAlignment = NSTextAlignmentCenter;
    //
    self.detailL.text = @"启用数字证书即可";
    self.detailL.textColor = [UIColor blackColor];
    self.detailL.font = FontSize_ElectronicSignature_Bold(16);
    self.detailL.textAlignment = NSTextAlignmentLeft;
    //
    [self.goToAuthenticatBtn setTitle:@"立即安装" forState:UIControlStateNormal];//footerv
    
}

//
- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneBtn.titleLabel.font = FontSize_ElectronicSignature_Nomail(14);
        [_oneBtn setTitle:@"合同交易必须" forState:UIControlStateNormal];
        [_oneBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [_oneBtn setImage:[UIImage imageNamed:@"checkbox_gou"] forState:UIControlStateNormal];
        [_oneBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        _oneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _oneBtn;
}
- (UIButton *)twoBtn{
    if (!_twoBtn) {
        _twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoBtn.titleLabel.font = FontSize_ElectronicSignature_Nomail(14);
        [_twoBtn setTitle:@"提高合同签署安全性" forState:UIControlStateNormal];
        [_twoBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [_twoBtn setImage:[UIImage imageNamed:@"checkbox_gou"] forState:UIControlStateNormal];
        [_twoBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        _twoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

     
    }
    return _twoBtn;
}
@end
