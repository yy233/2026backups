//
//  BankCardVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "BankCardVcTableViewCell.h"

@implementation BankCardVcTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.layer.cornerRadius = 7.5;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [Color_38BlueColor colorWithAlphaComponent:0.7];//basecolor
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(0, 16, 10, 16));
        }];
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.typeL];
        [self.backView addSubview:self.cardNumberL];
        [self.backView addSubview:self.lastNumL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.equalTo(_imgV.mas_width);
        make.top.equalTo(_imgV.superview.mas_top).offset(15);
        make.left.equalTo(_imgV.superview.mas_left).offset(15);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.right.equalTo(_titleL.superview);
        make.top.equalTo(_titleL.superview.mas_top).offset(10);
    }];
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom);
    }];
    [_cardNumberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(_titleL);
        make.width.offset(120);
        make.bottom.equalTo(_cardNumberL.superview.mas_bottom);
        make.top.equalTo(_typeL.mas_bottom);
    }];
    [_lastNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cardNumberL.mas_right);
        make.right.equalTo(_lastNumL.superview.mas_right);
        make.bottom.equalTo(_cardNumberL.superview.mas_bottom);
        make.top.equalTo(_typeL.mas_bottom);
    }];
}
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
        _titleL.font = FontSize_MoneyWallet_Bold(17);
        _titleL.textColor = [UIColor whiteColor];
    }
    return _titleL;
}
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.font = FontSize_MoneyWallet_Nomail(12);
        _typeL.textColor = [UIColor whiteColor];
    }
    return _typeL;
}
- (UILabel *)cardNumberL{
    if (!_cardNumberL) {
        _cardNumberL = [[UILabel alloc]init];
        _cardNumberL.font = FontSize_MoneyWallet_Bold(17);
        _cardNumberL.textColor = Y_RGBA(168, 209, 252, 1);
        _cardNumberL.text = @"**** **** **** ";
    }
    return _cardNumberL;
}
- (UILabel *)lastNumL{
    if (!_lastNumL) {
        _lastNumL = [[UILabel alloc]init];
        _lastNumL.font = FontSize_MoneyWallet_Bold(17);
        _lastNumL.textColor = [UIColor whiteColor];
    }
    return _lastNumL;
}
@end
