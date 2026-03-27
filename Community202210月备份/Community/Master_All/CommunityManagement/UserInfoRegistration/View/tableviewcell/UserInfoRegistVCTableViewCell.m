//
//  UserInfoRegistVCTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import "UserInfoRegistVCTableViewCell.h"

@interface UserInfoRegistVCTableViewCell ()
@property (nonatomic,strong) UIButton *editorBtn;//编辑资料
@property (nonatomic,strong) UIImageView *headImgV;
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIView *titleLabelBackGroundView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *genderImgV;
@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UILabel *detailtitleLabel;

@end
@implementation UserInfoRegistVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setModel:(UserInfoRegistModel *)model{
    _model = model;
    _titleLabel.text = model.realName;
    _detailtitleLabel.text = model.detailAddress;
    [_headImgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"head"]];
    [self typeLabelColorAndGenderImg:model.sex];
}
- (void)typeLabelColorAndGenderImg:(NSInteger)sex{
    switch (sex) {
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
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backGroundV];
        [self.contentView addSubview:self.headImgV];
        [self.backGroundV addSubview:self.titleLabelBackGroundView];
        [self.titleLabelBackGroundView addSubview:self.titleLabel];
        [self.titleLabelBackGroundView addSubview:self.genderImgV];
        [self.titleLabelBackGroundView addSubview:self.typeLabel];
        [self.backGroundV addSubview:self.detailtitleLabel];
        [self.backGroundV addSubview:self.editorBtn];
        [self setMainInfoUI];
    }
    return self;
}
- (void)editorBtnAction:(UIButton *)sender{
    if (_delegate &&[_delegate respondsToSelector:@selector(editorBtnActionWillPushVcToEditorMianUser)]) {
        [_delegate editorBtnActionWillPushVcToEditorMianUser];
    }
}
- (void)setMainInfoUI{
    _typeLabel.text = @"业主";
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backGroundV.superview.mas_top).offset(20);
        make.centerX.equalTo(_backGroundV.superview.mas_centerX);
        make.width.equalTo(_backGroundV.superview.mas_width).offset(-40);
        make.height.offset(123.0);
    }];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.superview.mas_top).offset(0);
        make.left.equalTo(_backGroundV.mas_left).offset(30);
        make.width.offset(64);
        make.height.equalTo(_headImgV.mas_width);
    }];
    [_titleLabelBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_bottom).offset(10);
        make.left.equalTo(_titleLabelBackGroundView.superview.mas_left).offset(20);
        make.height.offset(35);
        make.right.equalTo(_titleLabelBackGroundView.superview.mas_right).offset(-16);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.superview.mas_centerY);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(0);
        make.height.offset(35);
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
        make.width.offset(32);
        make.height.equalTo(_genderImgV.mas_width);//16
    }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_detailtitleLabel.superview.mas_bottom).offset(-5);
        make.right.equalTo(_detailtitleLabel.superview.mas_right).offset(-16);
    }];
    [_editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImgV.mas_bottom).offset(0);
        make.right.equalTo(_editorBtn.superview.mas_right).offset(-16);
        make.width.offset(70);
        make.height.offset(20);
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
        _detailtitleLabel.numberOfLines = 3;//0
    }
    return _detailtitleLabel;
}
- (UIImageView *)headImgV{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc]init];
//        _headImgV.layer.masksToBounds = YES;
//        _headImgV.layer.borderWidth = 1;
//        _headImgV.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _headImgV.layer.cornerRadius = 32;
//        _headImgV.backgroundColor = [UIColor whiteColor];
        
        _headImgV.image = [UIImage imageNamed:@"head"];//avatarUrl
        [_headImgV zy_cornerRadiusAdvance:32 rectCornerType:UIRectCornerAllCorners];
        [_headImgV zy_attachBorderWidth:1.0 color:[UIColor lightGrayColor]];

    }
    return _headImgV;
}
- (UIButton *)editorBtn{
    if (!_editorBtn) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editorBtn.layer.cornerRadius = 10;//w70  h20
        _editorBtn.layer.masksToBounds = YES;
        _editorBtn.backgroundColor = [UIColor clearColor];
        _editorBtn.layer.borderWidth = 1;
        _editorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _editorBtn.layer.borderColor = Y_RGBA(195, 216, 255, 1).CGColor;
        [_editorBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_editorBtn setTitleColor:Y_RGBA(38, 114, 249, 1) forState:UIControlStateNormal];
        }else{
            [_editorBtn setTitleColor:Y_RGBA(195, 216, 255, 1) forState:UIControlStateNormal];
        }
        [_editorBtn addTarget:self action:@selector(editorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
      
    }
    return _editorBtn;
}

@end

#pragma mark   +++++++++++++++++++++++++++++++ 家属cell ++++++++++++++++++++++++++++++
//与业主关系 1.夫妻 2.父子 3.母子 4.父女 5.母女 6.亲属
@interface UserInfoRegistVCOtherUserInfoTableViewCell ()
@property (nonatomic,strong) UIButton *editorBtn;//编辑资料
@property (nonatomic,strong) UIImageView *headImgV;
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UIView *titleLabelBackGroundView;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *genderImgV;
@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UILabel *detailtitleLabel;
@end

@implementation UserInfoRegistVCOtherUserInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.headImgV];
        [self.backGroundV addSubview:self.titleLabelBackGroundView];
        [self.titleLabelBackGroundView addSubview:self.titleLabel];
        [self.titleLabelBackGroundView addSubview:self.genderImgV];
        [self.titleLabelBackGroundView addSubview:self.typeLabel];
        [self.backGroundV addSubview:self.detailtitleLabel];
        [self.backGroundV addSubview:self.editorBtn];
        [self setOtherInfoUI];
    }
    return self;
}
-(void)setModel:(UserFamilyModel *)model{
    _model = model;
    _titleLabel.text = model.name;
    _detailtitleLabel.text = model.mobile;
//    [_imgV sd]
    [self reUptypeLabelColor];
    [self upFamilText];
}


- (void)editorBtnAction:(UIButton *)sender{
    if (_delegate &&[_delegate respondsToSelector:@selector(editorBtnActionWillPushVcToEditorFamilyMemberInfoWithModel:)]) {
        [_delegate editorBtnActionWillPushVcToEditorFamilyMemberInfoWithModel:_model];
    }
}

- (void)reUptypeLabelColor{
    switch (_model.sex) {
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
- (void)upFamilText{
    switch (_model.relation) {////与业主关系 1.夫妻 2.父子 3.母子 4.父女 5.母女 6.亲属
            //0714 选项只能为2项：家属、租客 (数据后台改为6 7 )
        case 0:
            _typeLabel.text = @"其他";
            break;
        case 1:
            _typeLabel.text = @"夫妻";
            break;
        case 2:
            _typeLabel.text = @"父子";
            break;
        case 3:
            _typeLabel.text = @"母子";
            break;
        case 4:
            _typeLabel.text = @"父女";
            break;
        case 5:
            _typeLabel.text = @"母女";
            break;
        case 6:
            _typeLabel.text = @"亲属";
            break;
        case 7:
            _typeLabel.text = @"租客";
            break;
        default:
            break;
    }
}
- (void)setOtherInfoUI{
    
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.centerX.equalTo(_backGroundV.superview.mas_centerX);
        make.width.equalTo(_backGroundV.superview.mas_width).offset(-40);
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
        make.width.offset(32);
        make.height.equalTo(_genderImgV.mas_width);//16
    }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.bottom.equalTo(_detailtitleLabel.superview.mas_bottom).offset(-20);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-50);
    }];
    [_editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_editorBtn.superview.mas_centerY).offset(0);
        make.right.equalTo(_editorBtn.superview.mas_right).offset(-16);
        make.width.offset(30);
        make.height.offset(40);
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
        [_headImgV zy_attachBorderWidth:1.0 color:[ThemeManager shareManager].mainContentBackgroundColor];



    }
    return _headImgV;
}
- (UIButton *)editorBtn{
    if (!_editorBtn) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editorBtn.layer.cornerRadius = 10;//w70  h20
        _editorBtn.layer.masksToBounds = YES;
        _editorBtn.backgroundColor = [UIColor clearColor];
//        [_editorBtn setImage:[ThemeImg themeImageWithBaseName:@""] forState:UIControlStateNormal];
        [_editorBtn setImage:[UIImage imageNamed:@"edit_grayColor"] forState:UIControlStateNormal];
        [_editorBtn addTarget:self action:@selector(editorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorBtn;
}

@end
#pragma mark   ++++++\+++++++++++++++++++++++++ 暂无登记人员 cell 20210224更 业主个人信息已经验证_房屋信息未登记 ++++++++++++++++++++++/++++++++
@interface UserInfoRegistVCNotUserInfoTableViewCell ()
@property (nonatomic,strong) UIButton *editorBtn;// 待认证
@property (nonatomic,strong) UIImageView *headImgV;
@property (nonatomic,strong) UIView *backGroundV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailtitleLabel;
@property (nonatomic,strong) UIImageView *tipImg;

@end
@implementation UserInfoRegistVCNotUserInfoTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor  = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backGroundV];
        [self.backGroundV addSubview:self.headImgV];
        [self.backGroundV addSubview:self.titleLabel];
        [self.backGroundV addSubview:self.detailtitleLabel];
        [self.backGroundV addSubview:self.tipImg];
        [self.backGroundV addSubview:self.editorBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    _titleLabel.text = @"业主认证";
    _detailtitleLabel.text = @"已实名认证";
    _editorBtn.userInteractionEnabled = NO;
    [_backGroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.centerX.equalTo(_backGroundV.superview.mas_centerX);
        make.width.equalTo(_backGroundV.superview.mas_width).offset(-40);
        make.height.offset(100.0);
    }];
    [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_backGroundV.superview.mas_centerY);
        make.left.equalTo(_headImgV.superview.mas_left).offset(15);
        make.width.offset(64);
        make.height.equalTo(_headImgV.mas_width);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImgV.mas_top);
        make.left.equalTo(_headImgV.mas_right).offset(10);
        make.height.offset(20);
        make.width.lessThanOrEqualTo(_titleLabel.superview.mas_width).offset(-55);
    }];
    [_detailtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
//        make.right.equalTo(_titleLabel.superview.mas_right).offset(-16);
        make.bottom.equalTo(_headImgV.mas_bottom);
        make.height.offset(20);
    }];
    [_tipImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_detailtitleLabel.mas_right).offset(5);
        make.centerY.equalTo(_detailtitleLabel);
        make.width.offset(12);
    }];
    [_editorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImgV.mas_centerY).offset(0);
        make.right.equalTo(_editorBtn.superview.mas_right).offset(-16);
        make.width.offset(100);
        make.height.offset(20);
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
            _backGroundV.layer.borderColor = [UIColor blackColor].CGColor;
        }else if([ThemeManager shareManager].type==ThemeType_Drak){
            _backGroundV.backgroundColor = Y_RGBA(17, 41, 87, 1);
        }
    }
    return _backGroundV;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleLabel;
}

- (UILabel *)detailtitleLabel{
    if (!_detailtitleLabel) {
        _detailtitleLabel = [[UILabel alloc]init];
        _detailtitleLabel.font = [UIFont boldSystemFontOfSize:12];
        _detailtitleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _detailtitleLabel;
}

- (UIImageView *)tipImg{
    if (!_tipImg) {
        _tipImg = [[UIImageView alloc]init];
        _tipImg.contentMode = UIViewContentModeScaleAspectFit;
        _tipImg.image = [UIImage imageNamed:@"Certified"];
    }
    return _tipImg;
}
- (UIImageView *)headImgV{
    if (!_headImgV) {
        _headImgV = [[UIImageView alloc]init];
        _headImgV.contentMode = UIViewContentModeScaleAspectFit;
//        _headImgV.layer.masksToBounds = YES;
//        _headImgV.layer.borderWidth = 1;
//        _headImgV.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        _headImgV.layer.cornerRadius = 32;
        _headImgV.image = [UIImage imageNamed:@"Informationregistration_Headportrait_Default"];
        [_headImgV zy_cornerRadiusAdvance:32 rectCornerType:UIRectCornerAllCorners];
    }
    return _headImgV;
}
- (UIButton *)editorBtn{
    if (!_editorBtn) {
        _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_editorBtn setTitle:@"房屋待认证" forState:UIControlStateNormal];
        _editorBtn.layer.cornerRadius = 10;//w70  h20
        _editorBtn.layer.masksToBounds = YES;
        _editorBtn.backgroundColor = [UIColor clearColor];
//        _editorBtn.layer.borderWidth = 1;
//        _editorBtn.layer.borderColor = Y_RGBA(195, 216, 255, 1).CGColor;
        [_editorBtn setTitleColor:Y_RGBA(195, 216, 255, 1) forState:UIControlStateNormal];
        [_editorBtn newAnBtnWithImg:[UIImage imageNamed:@"skip"]];
        [_editorBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    }
    return _editorBtn;
}
@end
