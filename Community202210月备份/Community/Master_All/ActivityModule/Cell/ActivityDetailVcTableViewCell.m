//
//  ActivityDetailVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/6/7.
//

#import "ActivityDetailVcTableViewCell.h"

@implementation ActivityDetailVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAKSELF
        [weakSelf.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.titleL];
        [self setYU];
    }
    return self;
}
- (void)setYU{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(25);
        make.height.offset(20);
        make.left.equalTo(_titleL.superview).offset(16);
        make.width.equalTo(_titleL.superview).offset(-32);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:15.0];
    }
    return _titleL;
}
@end


#pragma mark ==== ActivityDetailVcOwnUserInfoTableViewCell

@implementation ActivityDetailVcOwnUserInfoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.nameL];
        [self.backView addSubview:self.phoneL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    WEAKSELF
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameL.superview).offset(16);
        make.width.equalTo(_nameL.superview).offset(-32);
        make.height.offset(34);
        make.top.equalTo(weakSelf.titleL.mas_bottom).offset(10);
    }];
    [_phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(_nameL);
        make.top.equalTo(_nameL.mas_bottom).offset(8);
        make.height.offset(34);
    }];
}

- (LabelYu *)nameL{
    if (!_nameL) {
        _nameL = [[LabelYu alloc]init];
        _nameL.textColor = [ThemeManager shareManager].detailTextColor;
        _nameL.font = [UIFont systemFontOfSize:14.0];
        _nameL.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _nameL.layer.cornerRadius = 2;
        _nameL.layer.borderWidth = 0.5;
        _nameL.layer.masksToBounds = YES;
        if ([ThemeManager shareManager].type == ThemeType_White) {
            _nameL.layer.borderColor = Y_ColorWith16FromRGB(0xC5C9D4).CGColor;
            _nameL.layer.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6).CGColor;
        }else{
            _nameL.layer.borderColor = Y_ColorWith16FromRGB(0x122C5E).CGColor;
            _nameL.layer.backgroundColor = Y_ColorWith16FromRGB(0x2E4674).CGColor;
        }
        
    }
    return _nameL;
}
- (LabelYu *)phoneL{
    if (!_phoneL) {
        _phoneL = [[LabelYu alloc]init];
        _phoneL.textColor = [ThemeManager shareManager].detailTextColor;
        _phoneL.font = [UIFont systemFontOfSize:14.0];
        _phoneL.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _phoneL.layer.cornerRadius = 2;
        _phoneL.layer.borderWidth = 0.5;
        _phoneL.layer.masksToBounds = YES;
        if ([ThemeManager shareManager].type == ThemeType_White) {
            _phoneL.layer.borderColor = Y_ColorWith16FromRGB(0xC5C9D4).CGColor;
            _phoneL.layer.backgroundColor = Y_ColorWith16FromRGB(0xF0F1F6).CGColor;
        }else{
            _phoneL.layer.borderColor = Y_ColorWith16FromRGB(0x122C5E).CGColor;
            _phoneL.layer.backgroundColor = Y_ColorWith16FromRGB(0x2E4674).CGColor;
        }
    }
    return _phoneL;
}

@end

#pragma mark === ActivityDetailVcLongTextTableViewCell
//活动信息 长文本
@implementation ActivityDetailVcLongTextTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.lonTextL];
        [self setUI]; 
    }
    return self;
}
- (void)setUI{
    WEAKSELF
    [_lonTextL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lonTextL.superview).offset(16);
        make.width.equalTo(_lonTextL.superview).offset(-32);
        make.bottom.equalTo(_lonTextL.superview).offset(-10);
        make.top.equalTo(weakSelf.titleL.mas_bottom).offset(10);
    }];
}
- (UILabel *)lonTextL{
    if (!_lonTextL) {
        _lonTextL = [[UILabel alloc]init];
        _lonTextL.textColor = [ThemeManager shareManager].detailTextColor;
        _lonTextL.font = [UIFont systemFontOfSize:14.0];
        _lonTextL.numberOfLines = 0;
    }
    return _lonTextL;
}
@end

#pragma mark === ActivityDetailVcWrangLongTextTableViewCell
//活动须知警告
@implementation  ActivityDetailVcWrangLongTextTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.wrongTopBtn];
        [self setWongUI];
    }
    return self;
}
- (void)setWongUI{
    WEAKSELF
    [_wrongTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {//和titleL 同个水平位置
        make.left.top.height.equalTo(weakSelf.titleL);
        make.width.offset(80);
    }];
    weakSelf.titleL.hidden = YES;
}
- (UIButton *)wrongTopBtn{
    if (!_wrongTopBtn) {
        _wrongTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wrongTopBtn newAnBtnWithTextStr:@"活动须知"];
        [_wrongTopBtn newAnBtnWithTextColor: [ThemeManager shareManager].detailTextColor];
        [_wrongTopBtn newAnBtnWithFont:[UIFont systemFontOfSize:14.0]];
        [_wrongTopBtn newAnBtnWithImg: [UIImage imageNamed:@"tishi_icon"]];
    }
    return _wrongTopBtn;
}
@end

#pragma mark === ActivityDetailVcAddressAndTimeTableViewCell
//地址时间
@implementation  ActivityDetailVcAddressAndTimeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.addressL];
        [self.backView addSubview:self.timeFillFromL];
        [self.backView addSubview:self.timeActiveBeginL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.titleL.hidden = YES;
    WEAKSELF
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.height.equalTo(weakSelf.titleL);
        make.top.equalTo(_addressL.superview).offset(15);
    }];
    [_timeFillFromL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(_addressL);
        make.top.equalTo(_addressL.mas_bottom).offset(8);
    }];
    [_timeActiveBeginL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(_timeFillFromL);
        make.top.equalTo(_timeFillFromL.mas_bottom).offset(8);
    }];
}
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.textColor = [ThemeManager shareManager].detailTextColor;
        _addressL.font = [UIFont systemFontOfSize:14.0];
    }
    return _addressL;
}
- (UILabel *)timeFillFromL{
    if (!_timeFillFromL) {
        _timeFillFromL = [[UILabel alloc]init];
        _timeFillFromL.textColor = [ThemeManager shareManager].detailTextColor;
        _timeFillFromL.font = [UIFont systemFontOfSize:14.0];
    }
    return _timeFillFromL;
}
- (UILabel *)timeActiveBeginL{
    if (!_timeActiveBeginL) {
        _timeActiveBeginL = [[UILabel alloc]init];
        _timeActiveBeginL.textColor = [ThemeManager shareManager].detailTextColor;
        _timeActiveBeginL.font = [UIFont systemFontOfSize:14.0];
    }
    return _timeActiveBeginL;
}
@end

#pragma mark == ActivityDetailVcMianInfoTableViewCell
//主办方
@implementation  ActivityDetailVcMianInfoTableViewCell
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.backView addSubview:self.mainAddressL];
        [self.backView addSubview:self.phoneTitleL];
        [self.backView addSubview:self.phoneConentBtn];
        [self.backView addSubview:self.addressConentBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    WEAKSELF
    [_mainAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(weakSelf.titleL);
        make.top.equalTo(weakSelf.titleL.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.titleL).offset(-60);
    }];
    [_phoneTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(75);
        make.top.equalTo(_mainAddressL.mas_bottom).offset(8);
        make.height.left.equalTo(_mainAddressL);
    }];
    [_phoneConentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(_phoneTitleL);
        make.left.equalTo(_phoneTitleL.mas_right).offset(5);
    }];
    [_addressConentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(24);;
        make.centerY.equalTo(_addressConentBtn.superview);
        make.right.equalTo(_addressConentBtn.superview).offset(-34);
    }];
}
- (UILabel *)mainAddressL{
    if (!_mainAddressL) {
        _mainAddressL = [[UILabel alloc]init];
        _mainAddressL.textColor = [ThemeManager shareManager].detailTextColor;
        _mainAddressL.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _mainAddressL;
}
- (UILabel *)phoneTitleL{
    if (!_phoneTitleL) {
        _phoneTitleL = [[UILabel alloc]init];
        _phoneTitleL.textColor = [ThemeManager shareManager].detailTextColor;
        _phoneTitleL.font = [UIFont boldSystemFontOfSize:14.0];
        _phoneTitleL.text = @"联系电话：";
    }
    return _phoneTitleL;
}
- (UIButton *)phoneConentBtn{
    if (!_phoneConentBtn) {
        _phoneConentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneConentBtn newAnBtnWithTextColor: Y_ColorWith16FromRGB(0x2672F9)];
        [_phoneConentBtn newAnBtnWithFont: [UIFont boldSystemFontOfSize:14.0]];
    }
    return _phoneConentBtn;
}

- (UIButton *)addressConentBtn{
    if (!_addressConentBtn) {
        _addressConentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressConentBtn newAnBtnWithImg: [UIImage imageNamed:@"daohang_icon"]];
    }
    return _addressConentBtn;
}
@end

