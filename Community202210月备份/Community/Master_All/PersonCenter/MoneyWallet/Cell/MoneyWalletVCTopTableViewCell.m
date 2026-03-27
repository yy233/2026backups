//
//  MoneyWalletVCTopTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/2.
//

#import "MoneyWalletVCTopTableViewCell.h"

@implementation MoneyWalletVCTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithYuE:(double)yue andBCardNum:(NSInteger)bCardNum{
    self.moneyL.text = [NSString stringWithFormat:@"%0.2f",yue];
    self.titleLabelRight.text = [NSString stringWithFormat:@"银行卡%ld(张)",bCardNum];
    
}

#pragma mark ==
- (void)bangKaBtnAction{
    
    if (_delegate && [_delegate respondsToSelector:@selector(goToBangKaBtnAction)]) { 
        [_delegate goToBangKaBtnAction];
    }
}
- (void)yuemingxiCleanBtnAction{
    if (_delegate && [_delegate  respondsToSelector:@selector(showYuEMingXiBtnAction)]) {
        [_delegate showYuEMingXiBtnAction];
    }
}

#pragma markk=
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIColor *beginColor =  Y_RGBA(38, 114, 249, 1);
        UIColor *endColor =  Y_RGBA(56, 128, 251, 1);
        CGSize size = CGSizeMake(Screen_W-32, 160);//h
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, -5, 16));
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        //
        self.backView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor]; 
        self.backView.layer.cornerRadius = 5;
        //
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.titleLabelRight];
        //
        [self.backView addSubview:self.moneyL];
        [self.backView addSubview:self.bangKaBtn];
        //
        [self.backView addSubview:self.lineV];
        [self.backView addSubview:self.yuemingxiLabel];
        [self.backView addSubview:self.jiantouimgV];
        [self.backView addSubview:self.yuemingxiCleanBtn];
        [self setUI];
        
        //
        self.separatorInset = UIEdgeInsetsMake(0, Screen_W*2, 0, 16);
    }
    return self;
}
 
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview.mas_top).offset(20);
        make.left.equalTo(_titleL.superview.mas_left).offset(10);
        make.height.offset(30);
    }];
    [_titleLabelRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_titleL);
        make.right.equalTo(_titleLabelRight.superview.mas_right).offset(-10);
    }];
    //
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_moneyL.superview.mas_centerY).offset(-10);
        make.left.equalTo(_titleL);
        make.height.offset(30);
    }];
    [_bangKaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabelRight.mas_right);
        make.width.offset(60);
        make.height.offset(20);
        make.centerY.equalTo(_moneyL.mas_centerY);
    }];
    //
    [_lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyL.mas_bottom).offset(20);
        make.left.equalTo(_titleL.mas_left);
        make.right.equalTo(_titleLabelRight.mas_right);
        make.height.offset(1);
    }];
    //
    [_yuemingxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(_titleL);
        make.bottom.equalTo(_yuemingxiLabel.superview.mas_bottom).offset(-10);
    }];
    [_jiantouimgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bangKaBtn.mas_right);
        make.width.offset(5);
        make.height.offset(10);
        make.centerY.equalTo(_yuemingxiLabel);
    }];
    [_yuemingxiCleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_yuemingxiLabel);
        make.right.equalTo(_jiantouimgV);
    }];
    
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"余额（元）";
        _titleL.textColor = Y_RGBA(207, 220, 254, 1);
        _titleL.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _titleL;
}
- (UILabel *)titleLabelRight{
    if (!_titleLabelRight) {
        _titleLabelRight = [[UILabel alloc]init];
        _titleLabelRight.text = @"银行卡(张)";
        _titleLabelRight.textColor = Y_RGBA(207, 220, 254, 1);
        _titleLabelRight.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _titleLabelRight;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.text = @"0.00";
        _moneyL.textColor = [UIColor whiteColor];
        _moneyL.font = FontSize_MoneyWallet_Bold(30);
    }
    return _moneyL;
}
- (UIButton *)bangKaBtn{
    if (!_bangKaBtn) {
        _bangKaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bangKaBtn newAnBtnWithTextStr:@"去绑卡"];
        [_bangKaBtn newAnBtnWithTextColor:Y_RGBA(207, 220, 254, 1)];
        [_bangKaBtn newAnBtnWithLayerCorNerNum:10 withLayerLineWidth:0.5 withLayerLineColor:Y_RGBA(207, 220, 254, 1)];
        _bangKaBtn.titleLabel.font = FontSize_MoneyWallet_Nomail(12);
        [_bangKaBtn addTarget:self action:@selector(bangKaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bangKaBtn;
}
- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc]init];
        _lineV.backgroundColor = Y_RGBA(117, 164, 251, 1);
    }
    return _lineV;
}
- (UILabel *)yuemingxiLabel{
    if (!_yuemingxiLabel) {
        _yuemingxiLabel = [[UILabel alloc]init];
        _yuemingxiLabel.text = @"余额明细";
        _yuemingxiLabel.textColor = Y_RGBA(207, 220, 254, 1);
        _yuemingxiLabel.font = FontSize_MoneyWallet_Nomail(12);
    }
    return _yuemingxiLabel;
}

- (UIImageView *)jiantouimgV{
    if (!_jiantouimgV) {
        _jiantouimgV = [[UIImageView alloc]init];
        _jiantouimgV.image = [UIImage imageNamed:@"Wallet_Balancedetails"];
        _jiantouimgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _jiantouimgV;
}
- (UIButton *)yuemingxiCleanBtn{
    if (!_yuemingxiCleanBtn) {
        _yuemingxiCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yuemingxiCleanBtn addTarget:self action:@selector(yuemingxiCleanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yuemingxiCleanBtn;
}
@end
