//
//  ParkingMonthlyTenancyTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingMonthlyTenancyTableViewCell.h"

@implementation ParkingMonthlyTenancyTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
        }];
//        self.backView.backgroundColor = Color_11BlueColor;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.nameL];
        [self.backView addSubview:self.carParkingAddressShowL];
        [self.backView addSubview:self.typeInfoL];
        [self.backView addSubview:self.bangDingBeginTimeL];
        [self.backView addSubview:self.remainingDayNumL];
        [self.backView addSubview:self.editBtn];
        [self.backView addSubview:self.deletBtn];
        [self setBaseUI];
    }
    return self;
}
- (void)setBaseUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imgV.superview).multipliedBy(1.5);
        make.centerY.equalTo(_imgV.superview).multipliedBy(0.75);
        make.width.equalTo(_imgV.superview).multipliedBy(0.25);
        make.height.equalTo(_imgV.mas_width).multipliedBy(0.75);
    }];
   
    //
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameL.superview).offset(20);
        make.left.equalTo(_nameL.superview).offset(20);
        make.height.offset(20);
        make.width.lessThanOrEqualTo(_nameL.superview).multipliedBy(0.5).offset(-50);
    }];
    [_typeInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(_nameL);
        make.left.equalTo(_nameL.mas_right).offset(5);
        make.width.offset(45);
        make.right.lessThanOrEqualTo(_typeInfoL.superview).multipliedBy(0.5);
    }];
    [_carParkingAddressShowL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameL.mas_bottom).offset(5);
        make.left.equalTo(_nameL);
        make.width.lessThanOrEqualTo(_carParkingAddressShowL.superview).multipliedBy(0.5);
//        make.height.lessThanOrEqualTo(_bottomL.superview).multipliedBy(0.3);
    }];
    [_bangDingBeginTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_carParkingAddressShowL);
        make.width.lessThanOrEqualTo(_bangDingBeginTimeL.superview).multipliedBy(0.5);
        make.top.equalTo(_carParkingAddressShowL.mas_bottom);
        make.height.offset(20);
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_editBtn.superview.mas_centerX);
        make.width.equalTo(_editBtn.superview).multipliedBy(0.5).offset(3);
        make.height.offset(50);
        make.bottom.equalTo(_editBtn.superview);
    }];
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deletBtn.superview.mas_centerX);
        make.width.equalTo(_deletBtn.superview).multipliedBy(0.5).offset(3);
        make.height.offset(50);
        make.bottom.equalTo(_deletBtn.superview);
    }];
    //
    [_remainingDayNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bangDingBeginTimeL.mas_left);
        make.width.lessThanOrEqualTo(_remainingDayNumL.superview).multipliedBy(0.5);
        make.top.equalTo(_bangDingBeginTimeL.mas_bottom).offset(10);
        make.bottom.equalTo(_editBtn.mas_top).offset(-20);
    }];
}
 
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.image = [UIImage imageNamed:@"car01"];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}

- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.font =  [UIFont boldSystemFontOfSize:15];
    }
    _nameL.textColor = [ThemeManager shareManager].mainTextColor;
    return _nameL;
}
- (UILabel *)carParkingAddressShowL{
    if (!_carParkingAddressShowL) {
        _carParkingAddressShowL = [[UILabel alloc]init];
        _carParkingAddressShowL.font =  [UIFont systemFontOfSize:13];
        _carParkingAddressShowL.numberOfLines = 3;//车库名称
    }
    _carParkingAddressShowL.textColor =  [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    return _carParkingAddressShowL;
}
- (UILabel *)typeInfoL{
    if (!_typeInfoL) {
        _typeInfoL = [[UILabel alloc]init];
        _typeInfoL.font =  [UIFont systemFontOfSize:11];
        _typeInfoL.layer.cornerRadius = 8;
        _typeInfoL.layer.masksToBounds = YES;
        _typeInfoL.textAlignment = NSTextAlignmentCenter;
        _typeInfoL.text = @"月租车";
    }
    _typeInfoL.backgroundColor = Y_ColorWith16FromRGB(0xEBAC4F);
    _typeInfoL.textColor =  [UIColor whiteColor];
    return _typeInfoL;
}
//@property (nonatomic,strong) UILabel *bangDingBeginTimeL;//绑定时间
- (UILabel *)bangDingBeginTimeL{
    if (!_bangDingBeginTimeL) {
        _bangDingBeginTimeL = [[UILabel alloc]init];
        _bangDingBeginTimeL.font =  [UIFont systemFontOfSize:13];
        _bangDingBeginTimeL.numberOfLines = 1;
    }
    _bangDingBeginTimeL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];

    return _bangDingBeginTimeL;
}
- (UILabel *)remainingDayNumL{
    if (!_remainingDayNumL) {
        _remainingDayNumL = [[UILabel alloc]init];
        _remainingDayNumL.font =  [UIFont systemFontOfSize:13];
        _remainingDayNumL.numberOfLines = 2;
    }
    _remainingDayNumL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];

    return _remainingDayNumL;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn newAnBtnWithTextStr:@"月租续费"];
        [_editBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        [_editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    _editBtn.backgroundColor =  Y_ColorWith16FromRGB(0x2672F9);
    [_editBtn newAnBtnWithTextColor:[UIColor whiteColor]];

    return _editBtn;
}
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletBtn newAnBtnWithTextStr:@"移除车辆"];
        [_deletBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        [_deletBtn addTarget:self action:@selector(deletBtnAction:) forControlEvents:UIControlEventTouchUpInside];
         
    }
    if ([ThemeManager shareManager].type == ThemeType_Drak) {
            [_deletBtn newAnBtnWithTextColor:[UIColor whiteColor]];
             _deletBtn.backgroundColor =  Y_ColorWith16FromRGB(0x293F68);
    }else{
            [_deletBtn newAnBtnWithTextColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7]];
             _deletBtn.backgroundColor = [UIColor whiteColor];
    }
    return _deletBtn;
}
#pragma mark ==
- (void)editBtnAction{
    self.renewBlock();
}
- (void)deletBtnAction:(UIButton *)sender{
    self.deletBlock();
}

@end
