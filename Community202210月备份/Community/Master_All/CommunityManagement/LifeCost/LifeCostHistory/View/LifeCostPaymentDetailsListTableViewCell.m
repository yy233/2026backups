//
//  LifeCostPaymentDetailsListTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/11.
//

#import "LifeCostPaymentDetailsListTableViewCell.h"

@interface LifeCostPaymentDetailsListTableViewCell ()
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UILabel *moneyL;
@end

@implementation LifeCostPaymentDetailsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(LifeCostHistoryCostModel *)model{
    _model = model;
    _titleL.text = @"xx费 重庆xxxxxxxxxxx1xxxxxxxxx2xxxxxxxxx3xxxxx公司";
    _detailL.text = @"xxxxx时间";
    _moneyL.text = [NSString stringWithFormat:@"%0.2f",-108.18];
    _imgV.image =  [UIImage imageNamed:@"Water_charge_Icon_night"];
//    [UIImage imageNamed:@"Electricitycharge_Icon_night"];
//    [UIImage imageNamed:@"Gas_Icon_night"];
   
    _titleL.text = [NSString stringWithFormat:@"%@ %@",[TextShowWithModelStr textShowWithModelStr:model.typeName],[TextShowWithModelStr textShowWithModelStr:model.companyName]];
    _detailL.text = [TextShowWithModelStr textShowWithModelStr:model.orderTime];
    _moneyL.text = [NSString stringWithFormat:@"%0.2f",model.paymentBalance];
    [_imgV sd_setImageWithURL:[UrlWithString getURLWithStr:[TextShowWithModelStr textShowWithModelStr:model.icon]]];
    
}
#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailL];
        [self.contentView addSubview:self.moneyL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview.mas_top);
        make.left.equalTo(_imgV.superview.mas_left).offset(26);
        make.width.offset(20);
        make.bottom.equalTo(_imgV.superview.mas_bottom);
    }];
    [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview.mas_top);
        make.right.equalTo(_imgV.superview.mas_right).offset(-26);
        make.bottom.equalTo(_imgV.superview.mas_bottom);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.superview.mas_top).offset(5);
        make.left.equalTo(_imgV.mas_right).offset(5);
        make.right.equalTo(_moneyL.mas_left).offset(-5);
        make.height.offset(20);
    }];
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(0);
        make.left.equalTo(_imgV.mas_right).offset(5);
        make.right.equalTo(_moneyL.mas_left).offset(-5);
        make.bottom.equalTo(_detailL.superview.mas_bottom);
    }];
}
#pragma mark ===
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
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:15];
    }
    return _titleL;
}
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailL.font = [UIFont systemFontOfSize:12];
    }
    return _detailL;
}
- (UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL =[[UILabel alloc]init];
        _moneyL.textColor = [ThemeManager shareManager].mainTextColor;
        _moneyL.font = [UIFont boldSystemFontOfSize:17];
        _moneyL.textAlignment = NSTextAlignmentRight;
    }
    return _moneyL;
}
@end
