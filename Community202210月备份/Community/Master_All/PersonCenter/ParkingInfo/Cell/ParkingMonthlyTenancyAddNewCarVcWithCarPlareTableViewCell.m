//
//  ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/28.
//

#import "ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell.h"

@implementation ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell

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
        [self.backView addSubview:self.rightBtn];
        [self.backView addSubview:self.textFTopTuchBtn];
        WEAKSELF
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleL.mas_right).offset(1);
            make.top.bottom.equalTo(weakSelf.titleL);
            make.right.equalTo(weakSelf.textField.superview).offset(-16-5-20-5);
        }];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(_rightBtn.superview);
            make.right.equalTo(_rightBtn.superview).offset(0);
            make.left.equalTo(weakSelf.textField.mas_right);
        }];
        [_textFTopTuchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.textField);
        }];
         
    }
    return self;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn newAnBtnWithImg:[UIImage imageNamed:@"zhankai"]];
    }
    return _rightBtn;
}

- (UIButton *)textFTopTuchBtn{
    if (!_textFTopTuchBtn) {
        _textFTopTuchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _textFTopTuchBtn;
}
@end
