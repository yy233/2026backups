//
//  LifeCosePaymentOnePayInfoTopMoneyCell.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCosePaymentOnePayInfoTopMoneyCell.h"

@implementation LifeCosePaymentOnePayInfoTopMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setD{
    _moneyL.text = @"¥ 37.22";
    _detailL.text= @"应缴金额";
}

#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.topImgV];
        [self.contentView addSubview:self.moneyL];
        [self.contentView addSubview:self.detailL];
        [self setUI];
        [self setD];
    }
    return self;
}
- (void)setUI{
    _topImgV.image = [UIImage imageNamed:@"Livingexpenses_Electricitycharge_Icon"];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(30, 16, -20, 16));
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    [_topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImgV.superview.mas_top).offset(-25);
        make.height.offset(55);
        make.width.offset(55);
        make.centerX.equalTo(_topImgV.superview.mas_centerX);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(40);
        make.left.equalTo(_moneyL.superview.mas_left).offset(16);
        make.right.equalTo(_moneyL.superview.mas_right).offset(-16);
        make.top.equalTo(_topImgV.mas_bottom);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyL.mas_left);
        make.right.equalTo(_moneyL.mas_right);
        make.height.offset(20);
        make.top.equalTo(_moneyL.mas_bottom);
    }];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
//        _backView.layer.cornerRadius = 10;
//        _backView.layer.masksToBounds = YES;
//        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _backView;
}
- (UIImageView *)topImgV{
    if (!_topImgV) {
        _topImgV = [[UIImageView alloc]init];
//        _topImgV.layer.cornerRadius = 27.5;//55
//        _topImgV.layer.masksToBounds = YES;
        [_topImgV zy_cornerRadiusAdvance:27.5 rectCornerType:UIRectCornerAllCorners];

    }
    return _topImgV;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont boldSystemFontOfSize:30];
        _moneyL.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailL.font = [UIFont systemFontOfSize:15];
        _detailL.textAlignment = NSTextAlignmentCenter;
    }
    return _detailL;
}
@end
