//
//  MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell.h"

@implementation MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.chuXuKaBtn];
        [self.backView addSubview:self.xinYongKaBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_titleL.superview);
        make.height.offset(20);
    }];
    [_chuXuKaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(10);
        make.left.equalTo(_chuXuKaBtn.superview);
        make.width.equalTo(_chuXuKaBtn.superview).multipliedBy(0.5).offset(-5);
        make.height.offset(50);
    }];
    [_xinYongKaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(10);
        make.right.equalTo(_xinYongKaBtn.superview);
        make.width.equalTo(_xinYongKaBtn.superview).multipliedBy(0.5).offset(-5);
        make.height.offset(50);
    }];
    
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.text = @"请选择您要添加的银行卡类型";
        _titleL.font = FontSize_MoneyWallet_Nomail(14);
    }
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    return _titleL;
}
- (UIButton *)chuXuKaBtn{
    if (!_chuXuKaBtn) {
        _chuXuKaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chuXuKaBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(15)];
        [_chuXuKaBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_chuXuKaBtn newAnBtnWithTextStr:@"储蓄卡"];
        [_chuXuKaBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor:Color_38BlueColor];
        _chuXuKaBtn.selected = YES;
        [_chuXuKaBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Addbankcard_Type_normal"] selectedImg:[UIImage imageNamed:@"Addbankcard_Type_Select"]];
        [_chuXuKaBtn addTarget:self action:@selector(chuXuKaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chuXuKaBtn;
}
- (UIButton *)xinYongKaBtn{
    if (!_xinYongKaBtn) {
        _xinYongKaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xinYongKaBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(15)];
        [_xinYongKaBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_xinYongKaBtn newAnBtnWithTextStr:@"信用卡"];
        [_xinYongKaBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor:Color_38BlueColor];
        _xinYongKaBtn.selected = NO;
        [_xinYongKaBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"Addbankcard_Type_normal"] selectedImg:[UIImage imageNamed:@"Addbankcard_Type_Select"]];
        [_xinYongKaBtn addTarget:self action:@selector(xinYongKaBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xinYongKaBtn;
}

#pragma mark ==
- (void)chuXuKaBtnAction{
    if (self.chuXuKaBtn.selected==YES) {
        return;
    }
    _chuXuKaBtn.selected = YES;
    [_chuXuKaBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor:Color_38BlueColor];
    //
    _xinYongKaBtn.selected = NO;
    [_xinYongKaBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor: [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]];
    
    //
    if (_delegate && [_delegate respondsToSelector:@selector(cellChooseChuXuKa)]) {
        [_delegate cellChooseChuXuKa];
    }

}
- (void)xinYongKaBtnAction{
    if (self.xinYongKaBtn.selected==YES) {
        return;
    }
    _chuXuKaBtn.selected = NO;
    [_chuXuKaBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5]];
    //
    _xinYongKaBtn.selected = YES;
    [_xinYongKaBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0.5 withLayerLineColor:Color_38BlueColor];
    //
    if (_delegate && [_delegate respondsToSelector:@selector(cellChooseXinYongKa)]) {
        [_delegate cellChooseXinYongKa];
    }
}
@end
