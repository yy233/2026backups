//
//  ElectroniNewRealNameAuthenticationSuccessView.m
//  Community
//
//  Created by 余莹 on 2021/3/9.
//

#import "ElectroniNewRealNameAuthenticationSuccessView.h"

@implementation ElectroniNewRealNameAuthenticationSuccessView

 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.successImgV];
        [self addSubview:self.successL];
        [self addSubview:self.footerView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_successImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_successImgV.superview);
        make.centerY.equalTo(_successImgV.superview).offset(-80-KNavBarHeight);
        make.height.width.offset(120);
    }];
    [_successL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_successL.superview);
        make.top.equalTo(_successImgV.mas_bottom);
        make.height.offset(40);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.height.offset(90);
        make.centerY.equalTo(_footerView.superview.mas_centerY).multipliedBy(1.5);
    }];
}

#pragma mark ==
- (UIImageView *)successImgV{
    if (!_successImgV) {
        _successImgV = [[UIImageView alloc]init];
        _successImgV.image = [UIImage imageNamed:@"success_Face"];
        _successImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _successImgV;
}
- (UILabel *)successL{
    if (!_successL) {
        _successL = [[UILabel alloc]init];
        _successL.text = @"账户实名认证成功";
        _successL.font = FontSize_ElectronicSignature_Bold(20);
        _successL.textColor = Color_51BlackColor;
        _successL.textAlignment = NSTextAlignmentCenter;
    }
    return _successL;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"确认"];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _footerView;
}

/**
 @property (nonatomic,strong) UIImageView *successImgV;
 @property (nonatomic,strong) UILabel *successL;
 @property (nonatomic,strong) BaseTableViewFooterView *footerView;*/
@end
