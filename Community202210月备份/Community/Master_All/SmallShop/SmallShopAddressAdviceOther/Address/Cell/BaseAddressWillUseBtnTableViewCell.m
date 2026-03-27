//
//  BaseAddressWillUseBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/2.
//

#import "BaseAddressWillUseBtnTableViewCell.h"

#define orangeColor_UseBtn    Y_ColorWith16FromRGB(0xFFBA43)

@interface BaseAddressWillUseBtnTableViewCell ()

@property (nonatomic,strong) UILabel *addressTitleL;
@property (nonatomic,strong) UILabel *phoneTitleL;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UILabel *phoneL;
@property (nonatomic,strong) UIButton *useBtn;

@end

@implementation BaseAddressWillUseBtnTableViewCell

- (void)fillHistoryAddressStr:(NSString *)address andPhoneStr:(NSString *)phoneStr{
    self.phoneL.text = phoneStr;
    self.addressL.text = address;
}
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
     
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.addressTitleL];
        [self.contentView addSubview:self.phoneTitleL];
        [self.contentView addSubview:self.addressL];
        [self.contentView addSubview:self.phoneL];
        [self.contentView addSubview:self.useBtn];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(86);
        make.height.offset(30);
        make.centerY.equalTo(_useBtn.superview);
        make.right.equalTo(_useBtn.superview).offset(-26);
    }];
    //
    [_addressTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressTitleL.superview).offset(26);
        make.width.offset(35);
        make.height.offset(20);
        make.centerY.equalTo(_addressL);
    }];
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressTitleL.mas_right);
        make.top.equalTo(_addressL.superview).offset(10);
        make.right.equalTo(_useBtn.mas_left).offset(-10);
        make.height.greaterThanOrEqualTo(_addressTitleL.mas_height);
    }];
    
    //
    [_phoneTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneTitleL.superview).offset(26);
        make.width.offset(35);
        make.height.offset(20);
        make.bottom.equalTo(_phoneTitleL.superview).offset(-10);
      
    }];
    [_phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_phoneTitleL.mas_right);
        make.height.centerY.equalTo(_phoneTitleL);
        make.top.equalTo(_addressL.mas_bottom).offset(5);//间隔5
    }];
    

}

#pragma mark ==
- (UIButton *)useBtn{
    if (!_useBtn) {
        _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useBtn newAnBtnWithTextStr:@"使用此地址"];
        [_useBtn newAnBtnWithTextColor:orangeColor_UseBtn withBackColor:[UIColor whiteColor] withFont:[UIFont boldSystemFontOfSize:13.0] withLayerCorNerNum:15.0 withLayerLineWidth:1.0 withLayerLineColor:orangeColor_UseBtn];
        [_useBtn addTarget:self action:@selector(useBtnAction) forControlEvents:UIControlEventTouchUpInside];
     
    }
    return _useBtn;
}
- (UILabel *)addressTitleL{
    if (!_addressTitleL) {
        _addressTitleL = [[UILabel alloc]init];
        _addressTitleL.text = @"地址";
        _addressTitleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _addressTitleL.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _addressTitleL;
}

- (UILabel *)phoneTitleL{
    if (!_phoneTitleL) {
        _phoneTitleL = [[UILabel alloc]init];
        _phoneTitleL.text = @"电话";
        _phoneTitleL.textColor = Y_ColorWith16FromRGB(0x2B2C2F);
        _phoneTitleL.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _phoneTitleL;
}
- (UILabel *)phoneL{
    if (!_phoneL) {
        _phoneL = [[UILabel alloc]init];
        _phoneL.textColor = Y_ColorWith16FromRGB(0x6E727D);
        _phoneL.font = [UIFont systemFontOfSize:14.0];
    }
    return _phoneL;
}
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.textColor = Y_ColorWith16FromRGB(0x6E727D);
        _addressL.font = [UIFont systemFontOfSize:14.0];
        _addressL.numberOfLines = 0;
    }
    return _addressL;
}

- (void)useBtnAction{
    if (isNotNil(self.touchUseBtnBlock)) {
        self.touchUseBtnBlock();
    }
}
@end
