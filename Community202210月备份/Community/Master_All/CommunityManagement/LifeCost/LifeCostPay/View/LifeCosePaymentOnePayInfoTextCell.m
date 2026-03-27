//
//  LifeCosePaymentOnePayInfoTextCell.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCosePaymentOnePayInfoTextCell.h"

@implementation LifeCosePaymentOnePayInfoTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setD{
    _titleL.text = @"缴费户名";
    _detailL.text= @"文本文本文本文本文本文本应缴金本文本文本文本应缴金本文本应缴金额";
}

#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self setUI];
        [self setD];
    }
    return self;
}
- (void)setUI{
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleL.superview.mas_centerY);
        make.left.equalTo(_titleL.superview.mas_left).offset(26);
        make.width.offset(70);
        make.height.equalTo(_titleL.superview.mas_height);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_detailL.superview.mas_centerY);
        make.right.equalTo(_detailL.superview.mas_right).offset(-26);
        make.left.equalTo(_titleL.mas_right).offset(5);
        make.height.equalTo(_detailL.superview.mas_height);
    }];
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _titleL.font = [UIFont systemFontOfSize:13];
        _titleL.textAlignment = NSTextAlignmentLeft;
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [ThemeManager shareManager].mainTextColor;
        _detailL.font = [UIFont systemFontOfSize:13];
        _detailL.textAlignment = NSTextAlignmentRight;
    }
    return _detailL;
    
}
@end
