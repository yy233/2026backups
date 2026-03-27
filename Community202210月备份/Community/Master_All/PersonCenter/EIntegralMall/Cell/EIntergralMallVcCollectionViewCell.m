//
//  EIntergralMallVcCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallVcCollectionViewCell.h"

@implementation EIntergralMallVcCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backV];
        [self.backV addSubview:self.titleL];
        [self.backV addSubview:self.imgV];
        //
        [self.backV addSubview:self.eNumL];
        [self.backV addSubview:self.danWeiL];
        [self.backV addSubview:self.immediatelyChangeBtn];
        //
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backV.superview);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(_titleL.superview).offset(10);
        make.left.right.equalTo(_titleL.superview).offset(10);
        make.right.equalTo(_titleL.superview).offset(-10);
    }];
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_imgV.superview);
        make.top.equalTo(_titleL.mas_bottom).offset(20);//20
    }];
    //中间几个
    [_eNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleL.mas_left);
        make.top.equalTo(_titleL.mas_bottom);
        make.bottom.equalTo(_imgV.mas_top);
    }];
    [_danWeiL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_eNumL.mas_right).offset(5);
        make.top.bottom.equalTo(_eNumL);
    }];
    [_immediatelyChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_danWeiL.mas_right).offset(5);
        make.centerY.equalTo(_eNumL);
        make.width.offset(60);
        make.height.offset(15);
    }];
}
 
- (UIView *)backV{
    if (!_backV) {
        _backV = [[UIView alloc]init];
        _backV.backgroundColor = [UIColor whiteColor];
        _backV.layer.cornerRadius = 5;
        _backV.layer.masksToBounds = YES;
    }
    return _backV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [UIColor blackColor];
        _titleL.font = [UIFont systemFontOfSize:14];
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
//
- (UILabel *)eNumL{
    if (!_eNumL) {
        _eNumL = [[UILabel alloc]init];
        _eNumL.textColor = COlor_Red255;
        _eNumL.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _eNumL;
}
- (UILabel *)danWeiL{
    if (!_danWeiL) {
        _danWeiL = [[UILabel alloc]init];
        _danWeiL.textColor = Color_136GrayColor;
        _danWeiL.font = FontSize_MoneyWallet_Nomail(12);
        _danWeiL.text = @"E币";
    }
    return _danWeiL;
}
- (UIButton *)immediatelyChangeBtn{
    if (!_immediatelyChangeBtn) {
        _immediatelyChangeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_immediatelyChangeBtn newAnBtnWithImg:[UIImage imageNamed:@"rightSkip_white"]];
        [_immediatelyChangeBtn newAnBtnWithTextStr:@"立即兑换"];
        [_immediatelyChangeBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(10)];
        [_immediatelyChangeBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_immediatelyChangeBtn newAnBtnWithBackColor:COlor_Red255];
        [_immediatelyChangeBtn newAnBtnWithLayerCorNerNum:3 withLayerLineWidth:0 withLayerLineColor:COlor_Red255];
        [_immediatelyChangeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:1];
    }
    return _immediatelyChangeBtn;
}

@end
