//
//  MyHouseAddSubPersonVCLateShowTipTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/4/25.
//

#import "MyHouseAddSubPersonVCLateShowTipTextTableViewCell.h"

@implementation MyHouseAddSubPersonVCLateShowTipTextTableViewCell

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
        [self.contentView addSubview:self.showTextL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_showTextL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerX.centerY.equalTo(_showTextL.superview);
        make.left.equalTo(_showTextL.superview).offset(32);
        make.right.equalTo(_showTextL.superview).offset(-32);
    }];
}


- (UILabel *)showTextL{
    if (!_showTextL) {
        _showTextL = [[UILabel alloc]init];
        _showTextL.textColor = [ThemeManager shareManager].mainTextColor;
        _showTextL.font = [UIFont systemFontOfSize:13.0];
        _showTextL.text = @"关怀模式适用于没有手机的未成年用户及老年用户，仅用于门禁的访问。";
        _showTextL.numberOfLines = 0;
    }
    return _showTextL;
}
@end

#pragma mark ========================================================


@implementation MyHouseAddSubPersonVCLateShowTipTextAndBeginImgVTableViewCell
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
        [self.contentView addSubview:self.beginImgV];
        [self.contentView addSubview:self.showTextL];
        [self setUI];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setUI{
 
    [_beginImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showTextL.superview).offset(0);
        make.left.equalTo(_beginImgV.superview).offset(32-10);
        make.width.height.offset(16);
    }];
    [_showTextL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_beginImgV).offset(0);
        make.left.equalTo(_beginImgV.mas_right).offset(3);
        make.right.equalTo(_showTextL.superview).offset(-32);
    }];
}


- (UILabel *)showTextL{
    if (!_showTextL) {
        _showTextL = [[UILabel alloc]init];
        _showTextL.textColor = [ThemeManager shareManager].mainTextColor;
        _showTextL.font = [UIFont systemFontOfSize:12.0];
        _showTextL.text = @"已开启关怀模式的用户，无法使用APP应用，如需使用APP功能，需要开启并输入注册手机号，通过填写的手机号进行注册绑定关系，成为正式家庭成员。";
        _showTextL.numberOfLines = 0;
    }
    return _showTextL;
}
- (UIImageView *)beginImgV{
    if (!_beginImgV) {
        _beginImgV = [[UIImageView alloc]init];
        _beginImgV.contentMode = UIViewContentModeScaleAspectFit;
        _beginImgV.image = [UIImage imageNamed:@"tishi_icon"];
    }
    return _beginImgV;
}
@end
 
