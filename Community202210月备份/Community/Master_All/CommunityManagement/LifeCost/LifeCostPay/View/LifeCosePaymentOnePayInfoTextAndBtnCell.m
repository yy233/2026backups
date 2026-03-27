//
//  LifeCosePaymentOnePayInfoTextAndBtnCell.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCosePaymentOnePayInfoTextAndBtnCell.h"
#define Color_subBtn   Y_RGBA(13, 108, 252, 1)
@implementation LifeCosePaymentOnePayInfoTextAndBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setdddd{
    self.titleL.text = @"自动缴费";
    [_openChargeBtn setTitle:@"去开通" forState:UIControlStateNormal];
}

#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.detailL.hidden = YES;
        [self.contentView addSubview:self.openChargeBtn];
        [self setBtnUI];
        [self setdddd];
    }
    return self;
}
- (void)setBtnUI{
    [_openChargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.detailL.mas_right);
        make.height.equalTo(self.detailL.mas_height);
        make.width.offset(70);
        make.centerY.equalTo(self.detailL.mas_centerY);
    }];
}
#pragma mark==
- (UIButton *)openChargeBtn{
    if (!_openChargeBtn) {
        _openChargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openChargeBtn setTitleColor:Color_subBtn forState:UIControlStateNormal];
        _openChargeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _openChargeBtn;
}

@end
