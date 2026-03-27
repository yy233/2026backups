//
//  UserCertificationUserInfoTopTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/3/1.
//

#import "UserCertificationUserInfoTopTableViewCell.h"

@interface UserCertificationUserInfoTopTableViewCell ()
@end

@implementation UserCertificationUserInfoTopTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style  reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.headImgV];
        [self.backGroundV addSubview:self.titleLabelBackGroundView];
        [self.titleLabelBackGroundView addSubview:self.titleLabel];
        [self.titleLabelBackGroundView addSubview:self.genderImgV];
        [self.titleLabelBackGroundView addSubview:self.typeLabel];
        [self.backGroundV addSubview:self.detailtitleLabel];
         [self setUserInfoUI];
    }
    return self;
}
- (void)genderInfoWithIndex:(NSInteger)genderIndex{
//    [_headImgV.image sd]
    _headImgV.image = [UIImage imageNamed:@"Head_Certified"];//占位
    [self reUptypeLabelColor:genderIndex];;//性别
    self.typeLabel.text = @"已实名认证";//业主
}
 
 
- (void)reUptypeLabelColor:(NSInteger)genderIndex{
    switch (genderIndex) {
        case 0:
            _typeLabel.textColor = Color_Gender_boy_text;
            _typeLabel.backgroundColor = Color_Gender_boy_backV;//未知时
            _genderImgV.image = [ThemeManager shareManager].type==ThemeType_White ? [UIImage imageNamed:@"gender_boy"] :[UIImage imageNamed:@"gender_boy_WhiteColor"];
            break;
        case 1:
            _typeLabel.textColor = Color_Gender_boy_text;
            _typeLabel.backgroundColor = Color_Gender_boy_backV;
            _genderImgV.image =  [ThemeManager shareManager].type==ThemeType_White ? [UIImage imageNamed:@"gender_boy"] :[UIImage imageNamed:@"gender_boy_WhiteColor"];
            break;
        case 2:
            _typeLabel.textColor = Color_Gender_girl_text;
             _typeLabel.backgroundColor = Color_Gender_girl_backV;
            _genderImgV.image = [ThemeManager shareManager].type==ThemeType_White ? [UIImage imageNamed:@"gender_girl"] : [UIImage imageNamed:@"gender_girl_WhiteColor"];;
            break;
            
        default:
            break;
    }
  
}
- (void)setUserInfoUI{
    
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.centerX.equalTo(_backGroundV.superview.mas_centerX);
//        make.width.equalTo(_backGroundV.superview.mas_width).offset(-40);
        make.width.equalTo(_backGroundV.superview.mas_width);
        make.height.offset(70.0);
    }];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImgV.superview.mas_centerY).offset(0);
        make.left.equalTo(_headImgV.superview.mas_left).offset(15);
        make.width.offset(36);
        make.height.equalTo(_headImgV.mas_width);
    }];
    [_titleLabelBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top);
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.height.offset(20);
        make.right.equalTo(_titleLabelBackGroundView.superview.mas_right).offset(-50);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.superview.mas_centerY);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(0);
        make.height.equalTo(_titleLabel.superview.mas_height);
        make.width.lessThanOrEqualTo(_titleLabel.superview.mas_width).offset(-55);
    }];
    [_genderImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.superview.mas_centerY);
        make.left.equalTo(_titleLabel.mas_right).offset(5);
        make.width.offset(16);
        make.height.equalTo(_genderImgV.mas_width);
    }];
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.superview.mas_centerY);
        make.left.equalTo(_genderImgV.mas_right).offset(5);
        make.width.offset(65);//32
        make.height.equalTo(_genderImgV.mas_width);//16
    }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_detailtitleLabel.superview.mas_bottom).offset(-15);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-50);
    }];
}
#pragma mark ===
- (UIView *)backGroundV{
    if (!_backGroundV) {
        _backGroundV = [[UIView alloc]init];
        _backGroundV.layer.cornerRadius = 5;
        if ([ThemeManager shareManager].type==ThemeType_White) {
            _backGroundV.backgroundColor = [UIColor whiteColor];
            _backGroundV.layer.borderWidth = 1;
            _backGroundV.layer.borderColor = [UIColor whiteColor].CGColor;
        }else if([ThemeManager shareManager].type==ThemeType_Drak){
            _backGroundV.backgroundColor = Y_RGBA(17, 41, 87, 1);
        }
    }
    return _backGroundV;
}
//
- (UIView *)titleLabelBackGroundView{
    if (!_titleLabelBackGroundView) {
        _titleLabelBackGroundView = [[UIView alloc]init];
        _titleLabelBackGroundView.backgroundColor = [UIColor clearColor];
    }
    return _titleLabelBackGroundView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}
- (UIImageView *)genderImgV{
    if (!_genderImgV) {
        _genderImgV = [[UIImageView alloc]init];
        _genderImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _genderImgV;
}
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.layer.cornerRadius = 8;//16h 32w
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.textColor = Y_RGBA(18, 102, 253, 1);
        _typeLabel.backgroundColor = Y_RGBA(207, 224, 255, 1);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:10];
    }
    return _typeLabel;
}
//
- (UILabel *)detailtitleLabel{
    if (!_detailtitleLabel) {
        _detailtitleLabel = [[UILabel alloc]init];
        _detailtitleLabel.font = [UIFont boldSystemFontOfSize:12];
        _detailtitleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _detailtitleLabel;
}
- (UIImageView *)headImgV{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc]init];
        _headImgV.contentMode = UIViewContentModeScaleAspectFit;
//        _headImgV.layer.masksToBounds = YES;
//        _headImgV.layer.borderWidth = 1;
//        _headImgV.layer.borderColor = [ThemeManager shareManager].mainContentBackgroundColor.CGColor;//无 同背景色
//        _headImgV.layer.cornerRadius = 18;
        _headImgV.image = [UIImage imageNamed:@"person"];
        [_headImgV zy_cornerRadiusAdvance:18 rectCornerType:UIRectCornerAllCorners];
        [_headImgV zy_attachBorderWidth:1.0 color: [ThemeManager shareManager].mainContentBackgroundColor];

    }
    return _headImgV;
}
 

@end
