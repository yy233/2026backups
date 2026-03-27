//
//  HouseRentUserInfoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/30.
//

#import "HouseRentAllTypeUserInfoTableViewCell.h"

@implementation HouseRentAllTypeUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillUserInfoWithHouseData:(HouseRentDetailVcHouseUserModel *)houseUserModel{
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:houseUserModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    NSString *imgNameStr = (houseUserModel.isRealAuth == 2) ? @"yishim" : @"weishim";//实名 没实名
    [self.typeBtn newAnBtnWithImg:[UIImage imageNamed:imgNameStr]];
    if (houseUserModel.isRealAuth == 2) {//名字 以真名为优先级
        self.nameL.text = [TextShowWithModelStr textShowWithModelStr:houseUserModel.realName];
    }else{
        self.nameL.text = [TextShowWithModelStr textShowWithModelStr:houseUserModel.realName].length>0 ? ([TextShowWithModelStr textShowWithModelStr:houseUserModel.realName]) :  [TextShowWithModelStr textShowWithModelStr:houseUserModel.nickname];
    }
   
}
- (void)fillUserInfoWithBuniesShopData:(HouseRentDetailVcBuniessShopModelUserModel *)buniessUserModel{
    self.nameL.text = [TextShowWithModelStr textShowWithModelStr:buniessUserModel.realName];//
    [self.imgV sd_setImageWithURL:[UrlWithString getURLWithStr:buniessUserModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    NSString *imgNameStr = (buniessUserModel.isRealAuth == 2) ? @"yishim" : @"weishim";//实名 没实名
    [self.typeBtn newAnBtnWithImg:[UIImage imageNamed:imgNameStr]];
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.typeBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV.superview);
        make.width.height.offset(50);
        make.left.equalTo(_imgV.superview).offset(16);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV);
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.top.bottom.equalTo(_imgV);
        make.right.equalTo(_nameL.superview.mas_right).offset(-80);
    }];
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_imgV);
        make.width.offset(60);
        make.height.offset(20);
        make.right.equalTo(_typeBtn.superview).offset(-16);
    }];
    [_imgV zy_cornerRadiusRoundingRect];
}
#pragma mark ===
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill; //PHImageContentModeAspectFill;
        _imgV.layer.borderColor = Color_238GrayColor.CGColor;
    }
    return _imgV;
}
- (UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = [ThemeManager shareManager].mainTextColor;
        _nameL.font = [UIFont systemFontOfSize:14.0];
    }
    return _nameL;
}
- (UIButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _typeBtn;
}

@end
