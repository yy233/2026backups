//
//  ShippingAddressLastDefineAddressSwichTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/4/10.
//

#import "ShippingAddressLastDefineAddressSwichTableViewCell.h"

@implementation ShippingAddressLastDefineAddressSwichTableViewCell

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
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.defineSwitch];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(_titleL.superview);
        make.width.offset(200);
        make.height.offset(30);
    }];
    [_defineSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_defineSwitch.superview);
        make.right.equalTo(_defineSwitch.superview.mas_right).offset(0);
        make.width.offset(60);
        make.height.equalTo(_titleL);
    }];
    _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_Orders_Bold(15);
        _titleL.textColor = [UIColor blackColor];
        _titleL.text = @"设为默认地址";
    }
    return _titleL;
}
- (UISwitch *)defineSwitch{
    if (!_defineSwitch) {
        _defineSwitch = [[UISwitch alloc]init];
        _defineSwitch.onTintColor = Color_38BlueColor;
    }
    return _defineSwitch;
}
@end
