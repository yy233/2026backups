//
//  MoeyWalletAddBankHaVeCardTypeVcBackTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell.h"

@implementation MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell

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
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.titleL];
        [self setUI];
        self.backView.layer.cornerRadius = 5;
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_imgV.superview).offset(20);
        make.centerY.equalTo(_imgV.superview);
        make.width.height.offset(28);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleL.superview);
        make.left.equalTo(_imgV.mas_right).offset(5);
        make.right.equalTo(_titleL.superview);
        make.height.offset(20);
    }];
}
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_MoneyWallet_Nomail(15);
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}
@end
