//
//  UserCertificationChooseHouseDetailAddressTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/12/2.
//

#import "UserCertificationChooseHouseDetailAddressTableViewCell.h"
@interface UserCertificationChooseHouseDetailAddressTableViewCell ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *rightImg;

@end
@implementation UserCertificationChooseHouseDetailAddressTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.rightImg];
        [self setUI];
 
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleL.superview.mas_centerY);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.height.offset(20);
        make.width.offset(60);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textField.superview.mas_centerY);
        make.left.equalTo(_titleL.mas_right).offset(1);
        make.right.equalTo(_textField.superview.mas_right).offset(-28);//16+6+间隔
        make.height.offset(30);
    }];
    [_rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightImg.superview.mas_centerY);
        make.left.equalTo(_textField.mas_right).offset(5);
        make.right.equalTo(_rightImg.superview.mas_right).offset(-16);
        make.width.offset(5);
    }];
}
#pragma mark ===
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _backView;
    
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleL;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textColor = [ThemeManager shareManager].mainTextColor;
        _textField.font = [UIFont boldSystemFontOfSize:14];
        _textField.textAlignment = NSTextAlignmentRight;
        [_textField mainModuleAttributedPlaceholderNewColorWithStr:@"请选择"];
        _textField.userInteractionEnabled = NO;//不可写 仅仅用于选择

    }
    return _textField;
}
- (UIImageView *)rightImg{//展示尖头img
    if (!_rightImg) {
        _rightImg = [[UIImageView alloc]init];
//        _rightImg.image = [ThemeImg mainModulethemeImageWithBaseName:@"rightSkip"];
        _rightImg.image = [UIImage imageNamed:@"rightSkip"];
    }
    return _rightImg;
}
@end
