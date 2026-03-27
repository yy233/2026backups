//
//  ShippingAddressTextFieldAndRightBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "ShippingAddressTextFieldAndRightBtnTableViewCell.h"

@implementation ShippingAddressTextFieldAndRightBtnTableViewCell

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
        [self.backView addSubview:self.rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(_rightBtn.superview);
            make.width.offset(20);
            make.height.offset(20);
        }];
    }
    return self;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightBtn;
}

@end
