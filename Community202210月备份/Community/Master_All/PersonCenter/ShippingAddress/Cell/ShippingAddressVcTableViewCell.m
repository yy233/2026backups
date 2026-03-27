//
//  ShippingAddressVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "ShippingAddressVcTableViewCell.h"

@implementation ShippingAddressVcTableViewCell

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
        [self.backView addSubview:self.topL];
        [self.backView addSubview:self.addressL];
        [self.backView addSubview:self.infoL];
        [self.backView addSubview:self.editBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_topL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topL.superview).offset(10);
        make.left.right.equalTo(_topL.superview);
        make.height.offset(20);
    }];
    [_addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topL.mas_bottom);
        make.left.height.equalTo(_topL);
        make.right.equalTo(_addressL.superview.mas_right).offset(-70);
    }];
    [_infoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(_topL);
        make.top.equalTo(_addressL.mas_bottom);
    }];
    //
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_editBtn.superview.mas_right);
        make.centerY.equalTo(_editBtn.superview);
        make.width.offset(25);
        make.height.offset(25);
    }];
    _topL.textColor = [ThemeManager shareManager].mainTextColor;
    _addressL.textColor = [ThemeManager shareManager].mainTextColor;
    _infoL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
}

- (UILabel *)topL{
    if (!_topL) {
        _topL = [[UILabel alloc]init];
        _topL.font = FontSize_Orders_Bold(16);
        _topL.textColor = [UIColor blackColor];
    }
    return _topL;
}
- (UILabel *)addressL{
    if (!_addressL) {
        _addressL = [[UILabel alloc]init];
        _addressL.font = FontSize_Orders_Nomail(13);
        _addressL.textColor = [UIColor blackColor];
    }
    return _addressL;
}
- (UILabel *)infoL{
    if (!_infoL) {
        _infoL = [[UILabel alloc]init];
        _infoL.font = FontSize_Orders_Nomail(13);
        _infoL.textColor = Color_153GrayColor;
    }
    return _infoL;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn newAnBtnWithImg:[UIImage imageNamed:@"address_edit"]];
    }
    return _editBtn;
}
@end
